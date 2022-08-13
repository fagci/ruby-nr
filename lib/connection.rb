# frozen_string_literal: true

require 'socket'
Socket::Option.bool(:INET, :SOCKET, :KEEPALIVE, false)
Socket::Option.linger(true, 0)

# Container for host connection
class Connection
  attr_reader :ip, :port, :socket

  def initialize(ip, port, connect_timeout)
    @ip = ip
    @port = port
    @socket = Socket.tcp(ip, port, connect_timeout: connect_timeout)
    ObjectSpace.define_finalizer(self, proc { @socket.close })
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

  def readlines
    @socket.lines.map(&:chomp)
  end
end
