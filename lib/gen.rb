module Gen

  def Gen.gen_ip
    loop do
      intip = rand(0x1000000..0xE0000000)
      case intip
      when (0xA000000..0xAFFFFFF)  
      when (0x64400000..0x647FFFFF)
      when (0x7F000000..0x7FFFFFFF)
      when (0xA9FE0000..0xA9FEFFFF)
      when (0xAC100000..0xAC1FFFFF)
      when (0xC0000000..0xC0000007)
      when (0xC00000AA..0xC00000AB)
      when (0xC0000200..0xC00002FF)
      when (0xC0A80000..0xC0A8FFFF)
      when (0xC6120000..0xC613FFFF)
      when (0xC6336400..0xC63364FF)
      when (0xCB007100..0xCB0071FF)
      when (0xF0000000..0xFFFFFFFF)
      else
        return [intip].pack('N').unpack('CCCC').join('.')
      end
    end
  end

end
