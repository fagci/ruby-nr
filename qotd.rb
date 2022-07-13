#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/stalker'

QOTD_PORT = 17

Stalker.www do
  service :qotd
  profile :insane

  check do
    @qotd = []
    while (line = @socket.gets)
      @qotd << line.chomp
    end
    nil if @qotd.empty?
    self
  end

  on_result(true) do
    puts @ip
    puts '-' * 40
    puts @qotd.join(' ').sub(/\s+/, ' ')
    puts '-' * 40
  end
end
