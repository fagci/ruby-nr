#!/usr/bin/env ruby

require './lib/stalker'

stalker = Stalker.new(workers: 512)

stalker.work(17) do |ip, _, s|
  qotd = []
  while line = s.gets
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
