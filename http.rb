#!/usr/bin/env ruby

require 'socket'
require './lib/stalker'

TPL = DATA.each_line.map(&:chomp).join("\r\n")

Stalker.new(workers: 512).http do |ip, port, socket|
  socket.print(TPL % ip + "\r\n" * 2)
  title = socket.read.match(/(?<=\<title\>)([^<]+)/i).to_s.strip
puts "#{ip}:#{port} #{title}" unless title.empty?
end

__END__
GET / HTTP/1.0
Host: %s
User-Agent: Mozilla/5.0
