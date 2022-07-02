require 'etc'
require './lib/gen'

# Netstalking tool
class Stalker
  def initialize(options = {})
    @connect_timeout = options.fetch(:connect_timeout, 0.75)
    @workers_count = options.fetch(:workers, 64)
    @proc_count = Etc.nprocessors
    @thr_per_proc = @workers_count / @proc_count
    puts "Thr: #{@workers_count}, proc: #{@proc_count}, thr/proc: #{@thr_per_proc}"
  end

  # TODO: doc + get services from source
  services = {
    http: 80,
    ftp: 21,
    ssh: 22
  }
  services.each do |svc, port|
    define_method(svc) do |&block|
      @proc_count.times do
        Process.fork do
          workers = (1..@thr_per_proc).map do
            ::Thread.new { worker port, &block }
          end
          workers.map(&:join)
        rescue Interrupt => e
          # puts "Exiting..."
        end
      end
      Process.waitall
    rescue Interrupt => e
      # puts "Exiting..."
    end
  end

  def worker(port)
    loop do
      ip = Gen.gen_ip
      s = ::Socket.tcp(ip, port, connect_timeout: @connect_timeout)
      yield(ip, port, s)
      s.close
      rescue Errno::ECONNREFUSED, Errno::ETIMEDOUT, Errno::EHOSTUNREACH, Errno::ENETUNREACH, Errno::ECONNRESET
      next
    end
  end
end
