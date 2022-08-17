# frozen_string_literal: true

require 'etc'
require_relative 'gen'
require_relative 'connection'

require 'async/io'
require 'async/await'
require 'async/semaphore'

# Netstalking tool
class Stalker
  require_relative 'services'
  include Async::Await
  attr_accessor :results_count

  PROFILES = {
    fast: [0.75, 2048],
    mid: [1.5, 1024],
    slow: [2, 256],
    greedy_patient: [1, 2048],
    insane: [1.5, 4096]
  }.freeze

  def initialize
    @workers_count = 512
    @connect_timeout = 2
    @handlers = []
    @mutex = Mutex.new
    @max_open_files = Etc.sysconf(Etc::SC_OPEN_MAX)
    @proc_count = Etc.nprocessors
    @log_file = nil
    @log_fmt = '%<ip>s %<result>s'
    @output_fmt = nil
    @results_count = 0
    @results_max = nil
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
    path = if filename.include?('/')
             filename
           else
             "out/#{filename}"
           end
    @log_file = File.open(path, 'a')
  end

  def log_format(fmt)
    @log_fmt = fmt
  end

  def output_format(fmt)
    @output_fmt = fmt
  end

  def max_results(num)
    @results_max = num
  end

  def results_max_reached
    @results_count += 1
    @results_max && @results_count >= @results_max
  end

  alias output log

  alias check add_handler
  alias find add_handler
  alias locate add_handler
  alias on_result add_handler
  alias process add_handler
  alias request add_handler

  def init_log
    return unless @log_file

    log = @log_file
    fmt = @log_fmt
    warn "Log file: #{log.path}"
    on_result(true) do
      log.puts(fmt % to_h)
    end
  end

  def init_output
    return unless @output_fmt

    fmt = @output_fmt
    on_result(true) do
      puts(fmt % to_h)
    end
  end

  def work
    init_log
    init_output
    @sem = Async::Semaphore.new([@max_open_files, 4096].min)
    warn intro
    worker
  end

  private

  def intro
    <<~INTRO
      Port: #{@port_num}
      Max open files: #{@max_open_files}
      Connection timeout: #{(@connect_timeout * 1000).to_i} ms
      ----------------------------------------
    INTRO
  end

  async def worker
    working = true
    while working

      @sem.async do |task|
        ip = next_ip
        begin
          with_timeout(@connect_timeout) do
            Async::IO::Endpoint.tcp(ip, @port).connect do |socket|
              process_conn(Connection.new(task, ip, socket))
            end
          end
        rescue Errno::EMFILE
          sleep @connect_timeout
          retry
        rescue Errno::ETIMEDOUT, Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Errno::ENETUNREACH
          next
        rescue Errno::ECONNRESET, Errno::ENOPROTOOPT
          next
        rescue Async::TimeoutError
          next
        rescue Interrupt
          working = false
        end
      end

    end
  end

  def process_conn(conn)
    passed = @handlers.all? do |block, sync|
      next conn.instance_eval(&block) != false unless sync

      @mutex.synchronize do
        conn.instance_eval(&block) != false
      end
    end
    return unless passed
    raise Interrupt if results_max_reached
  end

  def next_ip
    Gen.gen_ip
  end
end
