#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/stalker'

Stalker.www do
  service :nntp
  profile :fast

  on_result do
    greeting = @socket.read(1024).to_s
    next if greeting.empty?

    code, = greeting.split.first
    next unless code == '200'

    puts "#{@ip}: #{greeting}"
    @socket << "LIST\r\n\r\n"
    puts @soxket.gets
  end
end
