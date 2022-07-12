# frozen_string_literal: true

RTSP_PATHS = %w[
  /1
  /0/1:1/main
  /live/h264
  /live
  /h264/ch1/sub/av_stream
  /stream1
  /live.sdp
  /image.mpg
  /axis-media/media.amp
  /1/stream1
  /ch01.264
  /live1.sdp
  /stream.sdp
].freeze

# RTSP plugin to check for most common streams
class Stalker
  def rtsp_stream(ip, port, socket)
    RTSP_PATHS.each_with_index do |path, i|
      uri = "rtsp://#{ip}:#{port}#{path}"

      socket << "DESCRIBE #{uri} RTSP/1.0\r\n"
      socket << "Accept: application/sdp\r\n"
      socket << "CSeq: #{i + 1}\r\n"
      socket << "User-Agent: Lavf59.16.100\r\n\r\n"

      resp = socket.recv(1024)
      break if resp.empty?

      status = resp.split(' ', 3)[1]

      break if status == '401'
      return uri if status == '200'
    rescue StandardError
      return false
    end
    false
  end
end
