#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/stalker'
require_relative 'lib/plugins/http'
require_relative 'lib/plugins/html'

Stalker.www do
  service :http

  request(&:http_get)
  process(&:get_html_title)

  on_result(true) do
    puts "#{@ip}: #{@title}"
  end
end
