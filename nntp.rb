#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/stalker'

stalker = Stalker.new(workers: 512)

stalker.work(119) do |ip, _, s|
  greeting = s.gets&.chomp.to_s
  next if greeting.empty?

  code, = greeting.split.first
  next unless code == '200'

  lock do
    puts "#{ip}: #{greeting}"
    s.puts "LIST"
    puts s.gets
  end
end
