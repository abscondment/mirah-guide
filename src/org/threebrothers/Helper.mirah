# Copyright (c) 2011 Brendan Ribera. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
