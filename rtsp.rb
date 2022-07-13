#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/stalker'
require_relative 'lib/plugins/rtsp'

Stalker.www do
  service :rtsp
  profile :fast

  find(&:rtsp_stream)

  on_result do |url|
    puts url
  end
end
