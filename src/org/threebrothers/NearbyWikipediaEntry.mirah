package org.threebrothers

import org.json.JSONObject

class NearbyWikipediaEntry

  macro def attr_reader(name_node)
    name = name_node.string_value
    quote do
      def `name`
        @`name`
      end
    end
  end
  
  def initialize(json:JSONObject)
    @id = long(json.optString('wikipediaUrl').hashCode)
    @title = json.optString 'title'
    @summary = json.optString 'summary'
    @url = String.format('http://%s', [json.optString('wikipediaUrl')].toArray)
    @thumbnail = json.optString 'thumbnailImg'
    @distance = float(json.optDouble 'distance')
    @latitude = float(json.optDouble 'lat')
    @longitude = float(json.optDouble 'lng')
  end

  attr_reader :id
  attr_reader :title
  attr_reader :summary
  attr_reader :url
  attr_reader :thumbnail
  attr_reader :distance
  attr_reader :latitude
  attr_reader :longitude
end
