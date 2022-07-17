# frozen_string_literal: true

require './lib/connection'

# RTSP plugin to check for most common streams
class Connection
  require './lib/rtsp_paths'
  RTSP_RESPONSE_REG = %r{^RTSP/\d.\d\s+(\d+)\s+}.freeze

  def rtsp_stream
    @uris = []

    RTSP_PATHS.each.with_index(1) do |path, cseq|
      uri = "rtsp://#{host}#{path}"
      resp = request(uri, cseq)
      break if resp.empty?

      matches = resp.match(RTSP_RESPONSE_REG)
      break unless matches

      status = matches[1]
      break if status == '401'

      @uris << uri if status == '200'
    end

    !@uris.empty?
  end

  def host
    @host ||= @port == 554 ? @ip : "#{ip}:#{port}"
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
