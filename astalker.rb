#!/usr/bin/env ruby
# frozen_string_literal: true

require 'async/io'
require 'async/await'
require 'async/semaphore'

require './lib/gen'
require './lib/connection'
require './lib/plugins/http'
require './lib/plugins/html'

class AStalker
  include Async::Await

  def initialize
    @sem = Async::Semaphore.new(1024)
  end

  def connect(ip, port)
    ep = Async::IO::Endpoint.tcp(ip, port)
    peer = with_timeout(0.75) { ep.connect }
    return yield Connection.new(ip, port, peer) if peer
  rescue Async::TimeoutError
  rescue Errno::ENETUNREACH, Errno::EHOSTUNREACH
  rescue Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::ENOPROTOOPT
  ensure
    peer.close if peer
  end

  def check
    connect(Gen.gen_ip, 80) do |conn|
      return if [
        conn.http_get,
        conn.get_html_title
      ].any? { |v| v == false }

      conn.instance_eval do
        puts @title
      end
    end
  end

  async def start
    loop do
      @sem.async do
        check
      end
    rescue Interrupt
      break
    end
  rescue Interrupt
    stop
  end
end

begin
  s = AStalker.new
  a = s.start
rescue Interrupt
end
