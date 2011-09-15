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
    url =  String.format '%s?username=%s&lat=%f&lng=%f', [self.endpoint, self.username,
                                                          loc.getLatitude, loc.getLongitude].toArray
    Log.d 'GeoNamesClient', "GET #{url}"
    req = HttpGet.new(url)
    AndroidHttpClient.modifyRequestToAcceptGzipResponse req
    response = self.client.execute(req)

    Log.d 'GeoNamesClient', "GOT #{response.getStatusLine.getStatusCode}"
    
    # get response body
    JSONObject.new Helper.get.inputstream_to_string(response.getEntity.getContent)
  end  
  
end
