#!/usr/bin/env ruby
# frozen_string_literal: true

require 'socket'
require_relative 'lib/stalker'

TPL = (DATA.each_line.map(&:chomp).join("\r\n") + "\r\n" * 2).freeze
TITLE_R = /(?<=\<title\>)[^<]+/i.freeze

Stalker.new(workers: 256, connect_timeout: 0.33).http do |ip, _port, socket|
  socket << TPL % ip
  title = socket.read.match(TITLE_R).to_s.strip
  lock do
    puts "#{ip} #{title}" unless title.empty?
  end
end

__END__
GET / HTTP/1.0
Host: %s
User-Agent: Mozilla/5.0
