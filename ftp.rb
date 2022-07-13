#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/ftp'
require_relative 'lib/stalker'

class Connection
  def anonymous_ftp
    ftp = Net::FTP.new #(@ip)
    @files = []
    ftp.set_socket @socket
    ftp.login
    puts 'Logged in'
    @files = ftp.list()
    puts 'Q'
    ftp.quit
    @files.empty?() ? nil : self
  rescue Net::FTPPermError, Net::FTPTempError, EOFError, Net::FTPConnectionError, Net::FTPProtoError => e
    # puts "E1: #{e}"
    nil
  rescue Net::ReadTimeout, Errno::ENOPROTOOPT => e
    # puts "E: #{e}"
    nil
  rescue StandardError => e
    # warn e
    nil
  end
end

Stalker.www do
  service :ftp
  profile :greedy_patient

  check(&:anonymous_ftp)

  on_result do
    print @ip, @files
  end
end
