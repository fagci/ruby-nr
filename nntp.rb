#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/stalker'

Stalker.www do
  service :nntp
  profile :fast

  on_result do
    greeting = read_lines()
    next if greeting.empty?

    code, = greeting.first
    next unless code == '200'

    puts "#{@ip}: #{greeting.join("\n")}"
    puts_rn('LIST')
    puts_rn
    puts @socket.gets
  end
end
