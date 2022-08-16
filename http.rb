#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/stalker'
require_relative 'lib/plugins/http'
require_relative 'lib/plugins/html'

Stalker.www do
  service :http
  output_format '%{ip}: %{title}'
  max_results 5

  request(&:http_get)
  process(&:get_html_title)
end
