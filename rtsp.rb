#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/stalker'
require_relative 'lib/plugins/rtsp'

Stalker.www do
  service :rtsp
  profile :fast
 
  check do |*args|
    rtsp_stream(*args)
  end

  on_result do |url|
    puts url
  end
end
