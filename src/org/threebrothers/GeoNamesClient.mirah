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

import android.location.Location
import android.net.http.AndroidHttpClient
import android.util.Log

import org.apache.http.HttpResponse
import org.apache.http.client.methods.HttpGet

import org.json.JSONObject

class GeoNamesClient
  macro def attr_accessor(name_node, type)
    name = name_node.string_value
    quote do
      def `name`
        @`name`
      end
      def `"#{name}_set"`(value:`type`)
        @`name` = value
      end
    end
  end
  
  class << self
    def get
      @instance ||= self.new
    end
  end

  attr_accessor :username, String
  attr_accessor :endpoint, String
  attr_accessor :client, AndroidHttpClient

  def initialize
    @endpoint = 'http://api.geonames.org/findNearbyWikipediaJSON'
    @username = 'mirahguide'
    @client = AndroidHttpClient.newInstance('MirahGuide')
  end

  def find_nearby_wikipedia_json(loc:Location)
    Log.d 'GeoNamesClient', "Fetching for #{loc}"
    url =  String.format '%s?username=%s&lat=%f&lng=%f&maxRows=%d',
                         [self.endpoint, self.username,
                          loc.getLatitude, loc.getLongitude,
                          25].toArray
    Log.d 'GeoNamesClient', "GET #{url}"
    req = HttpGet.new(url)
    AndroidHttpClient.modifyRequestToAcceptGzipResponse req
    response = self.client.execute(req)

    Log.d 'GeoNamesClient', "GOT #{response.getStatusLine.getStatusCode}"
    
    # get response body
    JSONObject.new Helper.get.inputstream_to_string(response.getEntity.getContent)
  end  
  
end
