#!/usr/bin/env ruby
# frozen_string_literal: true

require 'async/io'
require 'async/await'
require 'async/semaphore'

require './lib/gen'

class AStalker
  include Async::Await

  def initialize
    @sem = Async::Semaphore.new(1024)
  end

  def process(ip, peer)
    peer << "GET / HTTP/1.1\r\nHost: #{ip}\r\n\r\n"
    data = peer.read(1024)
    return unless data

    puts "#{Time.now} #{ip}"
  end

  async def start
    loop do
      ip = Gen.gen_ip
      @sem.async do
        peer = with_timeout(0.75) { Async::IO::Endpoint.tcp(ip, 80).connect }
        next unless peer

        process(ip, peer)
      rescue Errno::ECONNREFUSED, Async::TimeoutError, Errno::ENETUNREACH, Errno::EHOSTUNREACH, Errno::ECONNRESET,
             Errno::ENOPROTOOPT
      ensure
        peer.close if peer
      end
    rescue Interrupt
      break
    end
  end
end

s = AStalker.new
s.start
