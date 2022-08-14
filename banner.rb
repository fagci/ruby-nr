#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/stalker'

Stalker.www do
  port ARGV.first
  profile :insane

  process do
    puts_rn('Hello')
  @result = @socket.recv(1024)
  end

  output_format "%{ip}\n%{result}\n\n"
end
