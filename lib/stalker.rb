# frozen_string_literal: true

require 'etc'
require_relative 'gen'
require_relative 'connection'

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

  def initialize
    @workers_count = 64
    @connect_timeout = 0.75
    @handlers = []
    @mutex = Mutex.new
    @proc_count = Etc.nprocessors
    @log_file = nil
    @log_fmt = '%{ip} %{result}'
    @output_fmt = nil
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

  def add_handler(sync = false, &block)
    @handlers << [block, sync]
  end

  def log(filename)
    if filename.include?('/')
      path = filename
    else
      path = "out/#{filename}"
    end
    @log_file = File.open(path, 'a')
  end

  def log_format(fmt)
    @log_fmt = fmt
  end

  def output_format(fmt)
    @output_fmt = fmt
  end

  alias output log

  alias check add_handler
  alias find add_handler
  alias locate add_handler
  alias on_result add_handler
  alias process add_handler
  alias request add_handler

  def init_log
    if @log_file
      log = @log_file
      fmt = @log_fmt
      warn "Log file: #{log.path}"
      on_result(true) do
        log.puts(fmt % to_h)
      end
    end
  end

  def init_output
    if @output_fmt
      fmt = @output_fmt
      on_result(true) do
        puts(fmt % to_h)
      end
    end
  end

  def work
    init_log
    init_output
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
      Port: #{@port_num}
      Threads: #{@proc_count * @thr_per_proc}
      Connection timeout: #{(@connect_timeout * 1000).to_i} ms
      ----------------------------------------
    INTRO
  end

  def worker
    loop do
      process_conn(Connection.new(next_ip, @port_num, @connect_timeout))
    rescue Errno::ETIMEDOUT, Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Errno::ENETUNREACH
      next
    rescue Errno::ECONNRESET, Errno::ENOPROTOOPT => e
      # warn e
      next
    end
  end

  def process_conn(conn)
    @handlers.each do |block, sync|
      unless sync
        break if conn.instance_eval(&block) == false

        next
      end

      @mutex.synchronize do
        break if conn.instance_eval(&block) == false
      end
    end
  end

  def next_ip
    Gen.gen_ip
  end
end
