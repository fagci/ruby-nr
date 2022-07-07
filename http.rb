#!/usr/bin/env ruby

require 'socket'
require './lib/stalker'

TPL = (DATA.each_line.map(&:chomp).join("\r\n") + "\r\n" * 2).freeze
TITLE_R = /(?<=\<title\>)[^<]+/i.freeze

Stalker.new(workers: 256, connect_timeout: 0.33).http do |ip, _port, socket|
  socket.write(TPL % ip)
  title = socket.read.match(TITLE_R).to_s.strip
  puts "#{ip} #{title}" unless title.empty?
end

__END__
GET / HTTP/1.0
Host: %s
User-Agent: Mozilla/5.0
