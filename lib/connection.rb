# frozen_string_literal: true

# Container for host connection
class Connection
  attr_reader :ip, :port, :socket

  def initialize(ip, port, connect_timeout)
    @ip = ip
    @port = port
    @socket = Socket.tcp(ip, port, connect_timeout: connect_timeout)
    ObjectSpace.define_finalizer(self, proc { @socket.close })
  end
end
