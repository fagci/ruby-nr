# frozen_string_literal: true

# Generates IPs
module Gen
  LOCALHOST = (0x7F000000..0x7FFFFFFF).freeze # 127.0.0.0 - 127.255.255.255
  PRIVATE1 = (0xA000000..0xAFFFFFF).freeze # 10.0.0.0 - 10.255.255.255
  PRIVATE2 = (0x64400000..0x647FFFFF).freeze # 100.64.0.0 - 100.127.255.255
  PRIVATE3 = (0xAC100000..0xAC1FFFFF).freeze # 172.16.0.0 - 172.31.255.255
  PRIVATE4 = (0xC0000000..0xC00000FF).freeze # 192.0.0.0 - 192.0.0.255
  PRIVATE5 = (0xC0A80000..0xC0A8FFFF).freeze # 192.168.0.0 - 192.168.255.255
  LINK_LOCAL = (0xA9FE0000..0xA9FEFFFF).freeze # 169.254.0.0 - 169.254.255.255
  DOCUMENTATION = (0xC0000200..0xC00002FF).freeze # 192.0.2.0 - 192.0.2.255
  RESERVED1 = (0xc0586300..0xc05863ff).freeze # 192.88.99.0 - 192.88.99.255
  PRIVATE_BENCH = (0xC6120000..0xC613FFFF).freeze # 198.18.0.0 - 198.19.255.255
  DOCUMENTATION2 = (0xC6336400..0xC63364FF).freeze # 198.51.100.0 - 198.51.100.255
  DOCUMENTATION3 = (0xCB007100..0xCB0071FF).freeze # 203.0.113.0 - 203.0.113.255
  DOCUMENTATION4 = (0xe9fc0000..0xe9fc00ff).freeze # 233.252.0.0 - 233.252.0.255

  MULTICAST = (0xe0000000..0xefffffff).freeze # 224.0.0.0 - 239.255.255.255
  RESERVED2 = (0xf0000000..0xfffffffe).freeze # 240.0.0.0 - 255.255.255.254

  def self.gen_ip
    loop do
      intip = rand(0x01000000...0xffffffff) # exclude current network and local broadcast

      # 268M IPs each
      next if MULTICAST.cover? intip
      next if RESERVED2.cover? intip

      # 16M IPs each
      next if PRIVATE1.cover? intip
      next if LOCALHOST.cover? intip

      # 4M IPs
      next if PRIVATE2.cover? intip

      # 1M IPs
      next if PRIVATE3.cover? intip

      # 131K IPs
      next if PRIVATE_BENCH.cover? intip

      # 65K IPs
      next if LINK_LOCAL.cover? intip
      next if PRIVATE5.cover? intip

      # 256 IPs
      next if PRIVATE4.cover? intip
      next if DOCUMENTATION.cover? intip
      next if RESERVED1.cover? intip
      next if DOCUMENTATION2.cover? intip
      next if DOCUMENTATION3.cover? intip
      next if DOCUMENTATION4.cover? intip

      return [intip].pack('N').unpack('CCCC').join('.')
    end
  end
end
