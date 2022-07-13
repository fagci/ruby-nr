# frozen_string_literal: true

require 'etc'
require 'socket'
require_relative 'gen'
require_relative 'connection'

Socket::Option.bool(:INET, :SOCKET, :KEEPALIVE, false)
Socket::Option.linger(true, 0)

# Netstalking tool
class Stalker
  require_relative 'services'
  PROFILES = {
    fast: [0.33, 256],
    mid: [0.75, 128],
    slow: [2, 64],
    greedy_patient: [1, 256],
    insane: [0.75, 512]
  }.freeze

  attr_accessor :port_num

  def initialize(port_svc = nil, connect_timeout: 0.75, workers: 64, &block)
    @connect_timeout = connect_timeout
    @workers_count = workers
    @proc_count = Etc.nprocessors
    @mutex = Mutex.new
    @check_handlers = []
    @result_handlers = []
  end

  def self.www(&block)
    raise 'No block given' unless block_given?

    context = new
    context.instance_eval(&block)
    context.work(context.port_num)
  end

  def profile(p)
    @connect_timeout, @workers_count = PROFILES[p]
  end

  def service(svc)
    @port_num = SERVICES[svc]
    throw 'No such service' unless @port_num
  end

  def port(port_num)
    @port_num = port_num
  end

  def check(&block)
    @check_handlers << block
  end

  def on_result(locked=false, &block)
    @result_handlers << [locked, block]
  end

  alias find check
  alias locate check
  alias request check
  alias process check

  def work(port, &block)
    @thr_per_proc = @workers_count / @proc_count
    warn <<~EOM
    Threads: #{@workers_count} Proc: #{@proc_count} Threads/proc: #{@thr_per_proc}
    Connection timeout: #{@connect_timeout*1000} ms
    Port: #{port}
    ----------------------------------------
    EOM
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
        result = Connection.new({ ip: ip, port: port, socket: s })
        @check_handlers.each do |block|
          result = result.instance_eval(&block)
          break unless result
        end
        next unless result

        @result_handlers.each do |locked, block|
          next result.instance_exec(&block) unless locked
          
          @mutex.synchronize do
            result.instance_exec(&block)
          end
        end
      end
    rescue Errno::ECONNREFUSED, Errno::ETIMEDOUT, Errno::EHOSTUNREACH, Errno::ENETUNREACH, Errno::ECONNRESET, Errno::ENOPROTOOPT
      next
    end
  end
end
