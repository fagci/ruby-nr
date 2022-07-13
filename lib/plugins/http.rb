# frozen_string_literal: true

class Connection
  def http_get
    @socket << "GET / HTTP/1.1\r\n"
    @socket << "Host: #{@ip}\r\n"
    @socket << "Connection: close\r\n"
    @socket << "User-Agent: Mozilla/5.0\r\n\r\n"

    @html = @socket.read(1024).to_s
    self
  end
end
