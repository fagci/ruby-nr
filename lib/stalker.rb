# frozen_string_literal: true

require 'etc'
require 'socket'
require_relative 'gen'

Socket::Option.bool(:INET, :SOCKET, :KEEPALIVE, false)
Socket::Option.linger(true, 0)

# Netstalking tool
class Stalker
  # TODO: doc + get services from source
  SERVICES = {
    http: 80,
    ftp: 21,
    ssh: 22,
    rtsp: 554
  }.freeze

  attr_accessor :port_num

  def initialize(port_svc = nil, connect_timeout: 0.75, workers: 64, &block)
    @connect_timeout = connect_timeout
    @workers_count = workers
    @proc_count = Etc.nprocessors
    @mutex = Mutex.new

    return unless port_svc

    raise 'No block given' unless block_given?

    if port_svc.is_a?(Numeric) && block_given?
      work(port_svc, &block)
    elsif port_svc.is_a?(String) && block_given?
      send(port_svc.to_sym, &block)
    else
      raise 'Bad svc/port'
    end
  end

  def lock(&block)
    @mutex.synchronize(&block)
  end

  def self.www(&block)
    raise 'No block given' unless block_given?

    context = new
    context.instance_eval(&block)
    context.work(context.port_num)
  end

  def service(svc)
    @port_num = SERVICES[svc]
  end

  def port(port_num)
    @port_num = port_num
  end

  def profile(spd)
    @connect_timeout = {
      fast: 0.33,
      mid: 0.75,
      slow: 2,
      greedy_patient: 1
    }[spd]
    @workers_count = {
      fast: 256,
      mid: 128,
      slow: 64,
      greedy_patient: 256
    }[spd]
  end

  def check(&block)
    @check = block
  end

  def on_result(&block)
    @on_result = block
  end

  alias sync lock

  SERVICES.each do |svc, port|
    define_method(svc) do |&block|
      work(port, &block)
    end
  end

  def work(port, &block)
    @thr_per_proc = @workers_count / @proc_count
    warn "Thr: #{@workers_count}, proc: #{@proc_count}, thr/proc: #{@thr_per_proc}, ct: #{@connect_timeout}"
    @proc_count.times do
      Process.fork do
        workers = (1..@thr_per_proc).map do
          Thread.new { worker port, &block }
        end
        workers.map(&:join)
      rescue Interrupt
        workers.map(&:exit)
      end
    end
    Process.waitall
  rescue Interrupt
    warn 'Exiting'
  end

  private

  def worker(port, &block)
    loop do
      ip = Gen.gen_ip
      Socket.tcp(ip, port, connect_timeout: @connect_timeout) do |s|
        if @check
          result = @check.call(ip, port, s)
          next unless result
          next @on_result.call(result) if @on_result
        end
        next @on_result.call(ip, port, s) if @on_result

        instance_exec ip, port, s, &block
      end
    rescue Errno::ECONNREFUSED, Errno::ETIMEDOUT, Errno::EHOSTUNREACH, Errno::ENETUNREACH, Errno::ECONNRESET
      next
    rescue Errno::ENOPROTOOPT => e
      warn "E: #{ip}: #{e}"
    end
  end
end
