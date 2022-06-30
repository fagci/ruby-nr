require './lib/gen'

class Stalker
  def initialize(options = {})
    @connect_timeout = options.fetch(:connect_timeout, 0.75)
    @workers_count = options.fetch(:workers, 64)
  end

  # TODO: doc + get services from source
  {
    http: 80,
    ftp: 21,
    ssh: 22
  }.each do |svc, port|
    define_method(svc) do |&block|
      work(port, &block)
    end
  end

  def work(port)
    workers = (1..@workers_count).map do
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
