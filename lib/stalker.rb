require './lib/gen'

# Netstalking tool
class Stalker
  def initialize(options = {})
    @connect_timeout = options.fetch(:connect_timeout, 0.75)
    @workers_count = options.fetch(:workers, 64)
  end

  # TODO: doc + get services from source
  services = {
    http: 80,
    ftp: 21,
    ssh: 22
  }
  services.each do |svc, port|
    define_method(svc) do |&block|
      work(port, &block)
    end
  end

  def work(port, &block)
    workers = (1..@workers_count).map do
      ::Thread.new { worker port, &block }
    end
    workers.map(&:join)
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
