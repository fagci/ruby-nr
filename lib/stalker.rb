# frozen_string_literal: true

require 'etc'
require 'socket'
require_relative 'gen'

# Netstalking tool
class Stalker
  # TODO: doc + get services from source
  SERVICES = {
    http: 80,
    ftp: 21,
    ssh: 22
  }.freeze

  def initialize(*args, **opts, &block)
    @connect_timeout = opts.fetch(:connect_timeout, 0.75)
    @workers_count = opts.fetch(:workers, 64)
    @proc_count = Etc.nprocessors
    @thr_per_proc = @workers_count / @proc_count
    warn "Thr: #{@workers_count}, proc: #{@proc_count}, thr/proc: #{@thr_per_proc}, ct: #{@connect_timeout}"
    @mutex = Mutex.new

    return unless args.size == 1

    port_svc = args[0]
    raise 'No block given' unless block_given?

    work(port_svc, &block) if port_svc.is_a?(Numeric) && block_given?
    send(port_svc.to_sym, &block) if port_svc.is_a?(String) && block_given?
    raise 'Bad svc/port'
  end

  def self.fast(*args, &block)
    new(*args, workers: 512, connect_timeout: 0.5, &block)
  end

  def lock(&block)
    @mutex.synchronize(&block)
  end

  alias sync lock

  SERVICES.each do |svc, port|
    define_method(svc) do |&block|
      work(port, &block)
    end
  end

  def work(port, &block)
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
        instance_exec ip, port, s, &block
      end
    rescue Errno::ECONNREFUSED, Errno::ETIMEDOUT, Errno::EHOSTUNREACH, Errno::ENETUNREACH, Errno::ECONNRESET
      next
    rescue Errno::ENOPROTOOPT => e
      warn "E: #{ip}: #{e}"
    end
  end
end
