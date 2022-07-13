# frozen_string_literal: true

require './lib/connection'
require './lib/rtsp_paths'

# RTSP plugin to check for most common streams
class Connection
  def rtsp_stream()
    @uris = []
    RTSP_PATHS.each_with_index do |path, i|
      uri = "rtsp://#{@ip}:#{@port}#{path}"
      resp = request(uri, i + 1)
      break if resp.empty?

      matches = resp.match(%r{^RTSP/\d.\d\s+(\d+)\s+})
      break unless matches

      status = matches[1]
      break if status == '401'

      @uris << uri if status == '200'
    end

    @uris.empty?() ? nil : self
  end

  def request(uri, cseq)
      @socket << "DESCRIBE #{uri} RTSP/1.0\r\n"
      @socket << "Accept: application/sdp\r\n"
      @socket << "CSeq: #{cseq}\r\n"
      @socket << "User-Agent: Lavf59.16.100\r\n\r\n"

      @socket.recv(1024)
    rescue StandardError
      ''
  end
end
