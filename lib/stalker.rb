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

  def initialize
    @workers_count = 64
    @connect_timeout = 0.75
    @handlers = []
    @mutex = Mutex.new
    @proc_count = Etc.nprocessors
  end

  def self.www(&block)
    raise 'No block given' unless block_given?

    context = new
    context.instance_eval(&block)
    context.work
  end

  def profile(prof)
    @connect_timeout, @workers_count = PROFILES[prof]
  end

  def service(svc)
    @port_num = SERVICES[svc]
    throw 'No such service' unless @port_num
  end

  def port(port_num)
    @port_num = port_num
  end

  def add_handler(locked = false, &block)
    @handlers << [locked, block]
  end

  alias on_result add_handler
  alias find add_handler
  alias locate add_handler
  alias request add_handler
  alias process add_handler

  def work
    @thr_per_proc = @workers_count / @proc_count
    warn intro
    @proc_count.times do
      Process.fork do
        workers = (1..@thr_per_proc).map do
          Thread.new { worker }
        end
        workers.each(&:join)
      rescue Interrupt
        workers.each(&:exit)
      end
    end
    Process.waitall
  rescue Interrupt
    warn 'Exiting'
  end

  private

  def intro
    <<~INTRO
      Threads: #{@workers_count} Proc: #{@proc_count} Threads/proc: #{@thr_per_proc}
      Connection timeout: #{@connect_timeout * 1000} ms
      Port: #{@port_num}
      ----------------------------------------
    INTRO
  end

  def worker
    loop do
      process_conn(Connection.new(Gen.gen_ip, @port_num, @connect_timeout))
    rescue Errno::ECONNREFUSED, Errno::ETIMEDOUT, Errno::EHOSTUNREACH, Errno::ENETUNREACH, Errno::ECONNRESET,
           Errno::ENOPROTOOPT
      next
    end
  end

  def process_conn(conn)
    @handlers.each do |locked, block|
      @mutex.lock if locked
      conn = conn.instance_eval(&block)
      @mutex.unlock if locked
      break unless conn
    end
  end
end
