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
