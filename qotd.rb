#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/stalker'

QOTD_PORT = 17

Stalker.new(QOTD_PORT, workers: 512) do |ip, _, s|
  qotd = []
  while (line = s.gets)
    qotd << line.chomp
  end
  next if qotd.empty?

  lock do
    puts ip
    puts '-' * 40
    puts qotd.join(' ').sub(/\s+/, ' ')
    puts '-' * 40
  end
end
