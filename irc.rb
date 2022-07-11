#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/stalker'

IRC_PORT = 6667

Stalker.fast(IRC_PORT) do |ip|
  puts ip
end
