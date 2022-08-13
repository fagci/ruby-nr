#!/usr/bin/env ruby
# frozen_string_literal: true
require_relative 'lib/stalker'
require_relative 'lib/plugins/http'

REQUEST = [
  'GET / HTTP/1.1',
  'Host: \'"'
].freeze

Stalker.www do
  service :http
  profile :insane

  request do
    http_request_a REQUEST
    @code == 500
  end

  log 'invalid-host-500.txt'
  log_format "%{ip}\n%{body}\n---\n"
end
