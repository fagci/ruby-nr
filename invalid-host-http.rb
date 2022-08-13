#!/usr/bin/env ruby
# frozen_string_literal: true
 require_relative 'lib/stalker'

Stalker.www do
  port 80
  log 'invalid-host-500.txt'
  log_format <<~FMT
    %{ip}
    %{result}
    ---
    
  FMT

  request do
    @socket << "GET / HTTP/1.1\r\n"
    @socket << "Host: '\"\r\n\r\n"


    response = []
    while (line = @socket.gets)
      response << line.chomp
    end
    next false if response.empty?
    next false unless response.first =~ %r{^HTTP\S+\s+500}
    @result = response.join("\n")
    true
  end
end
