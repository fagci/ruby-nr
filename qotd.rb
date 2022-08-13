#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/stalker'

QOTD_PORT = 17

Stalker.www do
  service :qotd
  profile :insane

  check do
    qotd = read_lines()
    @qotd = qotd.join(' ').gsub(/\s+/, ' ').strip
    false if @qotd.empty?
  end

  on_result(true) do
    puts @ip
    puts '-' * 40
    puts @qotd
    puts '-' * 40
  end
end
