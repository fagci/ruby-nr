# frozen_string_literal: true

require 'socket'
Socket::Option.bool(:INET, :SOCKET, :KEEPALIVE, false)
Socket::Option.linger(true, 0)

# Container for host connection
class Connection
  attr_accessor :ip, :port, :socket

  def initialize(task, ip, port, connect_timeout)
    @ip = ip
    @port = port
    this = self
    task.with_timeout(connect_timeout) do
      this.socket = Async::IO::Endpoint.tcp(this.ip, port).connect
      ObjectSpace.define_finalizer(self, proc { this.socket.close })
    end
  end

  def to_h
    instance_variables.map do |var| 
      [var.to_s[1..-1].to_sym, instance_variable_get(var)]
    end.to_h
  end

  def puts_rn(str)
    @socket << "#{str}\r\n"
  end

  def puts_n2rn(str)
    @socket << str.gsub("\n", "\r\n")
  end

  def read_lines
    @socket.lines.map(&:chomp)
  end

  def read(len=nil)
    @socket.read(len)
  end
end
