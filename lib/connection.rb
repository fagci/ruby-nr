# frozen_string_literal: true

# Container for host connection
class Connection
  attr_accessor :ip, :port, :socket

  def initialize(params = {})
    params.each { |key, value| send "#{key}=", value }
  end
end
