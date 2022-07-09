#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/ftp'
require_relative 'lib/stalker'

Stalker.new(workers: 256, connect_timeout: 0.33).ftp do |ip, _port, socket|
  ftp = Net::FTP.new
  # ftp.passive = true
  begin
    ftp.set_socket socket
    # ftp.connect("#{ip}")
    ftp.login
    puts 'Logged in'
    lst = ftp.list('*')
    puts 'Q'
    ftp.quit
    puts ip
    puts lst.join("\n") unless lst.empty?
  rescue Net::FTPPermError, Net::FTPTempError, EOFError, Net::FTPConnectionError, Net::FTPProtoError => e
    puts "E1: #{e}"
  rescue Net::ReadTimeout, Errno::ENOPROTOOPT => e
    puts "E: #{e}"
  end
end
