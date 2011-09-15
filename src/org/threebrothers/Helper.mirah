package org.threebrothers

import java.io.InputStream
import java.io.InputStreamReader
import java.io.IOException

class Helper
  
  class << self
    def get
      @instance ||= self.new
    end
  end

  # HACK HACK!
  #
  # Can't use 'loop' in static methods.
  def inputstream_to_string(is:InputStream)
    buffer = char[0x10000]
    out = StringBuilder.new
    inreader = InputStreamReader.new(is, "UTF-8")
    begin
      read = int(0)
      loop do
        read = inreader.read buffer, 0, buffer.length
        if read > 0
          out.append buffer, 0, read
        end
        break unless read >= 0
      end
    rescue IOException => ex
    ensure
      inreader.close
    end      
    
    out.toString
  end
end
