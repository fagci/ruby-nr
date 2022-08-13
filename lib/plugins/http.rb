# frozen_string_literal: true

require 'net/http'
require 'stringio'

class Connection
  def http_get(len=1024)
    @socket << "GET / HTTP/1.1\r\n"
    @socket << "Host: #{@ip}\r\n"
    @socket << "Connection: close\r\n"
    @socket << "User-Agent: Mozilla/5.0\r\n\r\n"

    get_response
    self
  end

  def http_request_a(arr)
    has_empty_line = false
    arr.each do |line|
      @socket << "#{line}\r\n"
      has_empty_line = true if line.empty?
    end
    @socket << "\r\n" unless has_empty_line
    get_response
    self
  end

  def get_response
    @html = @socket.read.to_s

    resp_io = StringIO.new(@html)
    buf_io = Net::BufferedIO.new(resp_io)

    @response = Net::HTTPResponse.read_new(buf_io)
    @response.reading_body(buf_io, true) { yield res if block_given? }
    @code = @status_code = @response.code.to_i
    @head = @response.to_hash
    @body = @response.body
    @response
  end
end
