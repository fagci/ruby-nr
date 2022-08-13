#!/usr/bin/env ruby
# frozen_string_literal: true
require_relative 'lib/stalker'
require_relative 'lib/plugins/http'

REQUEST = <<~REQUEST
GET / HTTP/1.1
Host: '"

REQUEST

Stalker.www do
  port 80
  profile :insane
  log 'invalid-host-500.txt'
  log_format <<~FMT
    %{ip}
    %{body}
    ---
    
  FMT

  request do
    puts_n2rn REQUEST

    get_response
    next false unless @code == 500

    true
  end
end
