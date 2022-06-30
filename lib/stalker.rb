require './lib/gen'

class Stalker
  def initialize(options = {})
    @connect_timeout = options.fetch(:connect_timeout, 0.75)
    @workers_count = options.fetch(:workers, 64)
  end

  def http(&block)
    work(80, &block)
  end

  def work(port)
    workers = (1..@workers_count).map do |_i|
      Thread.new do
        loop do
          ip = Gen.gen_ip
          s = Socket.tcp(ip, 80, connect_timeout: @connect_timeout)
          yield(ip, port, s)
          s.close
        rescue Errno::ECONNREFUSED, Errno::ETIMEDOUT, Errno::EHOSTUNREACH, Errno::ENETUNREACH, Errno::ECONNRESET
          next
        end
      end
    end
    workers.map(&:join)
  end
end
