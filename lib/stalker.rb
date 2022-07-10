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

  def initialize(options = {})
    @connect_timeout = options.fetch(:connect_timeout, 0.75)
    @workers_count = options.fetch(:workers, 64)
    @proc_count = Etc.nprocessors
    @thr_per_proc = @workers_count / @proc_count
    warn "Thr: #{@workers_count}, proc: #{@proc_count}, thr/proc: #{@thr_per_proc}"
    @mutex = Mutex.new
  end

  def lock(&block)
    @mutex.synchronize(&block)
  end

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

  def worker(port, &block)
    loop do
      ip = Gen.gen_ip
      s = Socket.tcp(ip, port, connect_timeout: @connect_timeout)
      instance_exec ip, port, s, &block
      s.close
    rescue Errno::ECONNREFUSED, Errno::ETIMEDOUT, Errno::EHOSTUNREACH, Errno::ENETUNREACH, Errno::ECONNRESET
      next
    rescue Errno::ENOPROTOOPT => e
      warn "E: #{ip}: #{e}"
    end
  end
end
