#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/stalker'

Stalker.www do
  port 6667
  on_result do |ip|
    puts ip
  end
end
