#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/stalker'

QOTD_PORT = 17

stalker = Stalker.new(workers: 512)

stalker.work(QOTD_PORT) do |ip, _, s|
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
