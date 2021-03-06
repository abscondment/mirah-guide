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

import android.content.Context

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter

import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView

import org.json.JSONObject

import java.util.ArrayList

class NearbyWikipediaAdapter < BaseAdapter

  def initialize(context:Context)
    @data = ArrayList.new
    @context = context
    @inflater = LayoutInflater(@context.getSystemService Context.LAYOUT_INFLATER_SERVICE)
  end

  def json_set(json:JSONObject)
    if json.has 'geonames'
      list = json.getJSONArray 'geonames'
      @data = ArrayList.new
      list.length.times do |i|
        entry = NearbyWikipediaEntry.new list.getJSONObject(i)
        @data.add entry
      end
      notifyDataSetChanged
    end
  end
  
  def areAllItemsEnabled
    true
  end

  def hasStableIds
    true # we'll use the ones returned in the json
  end

  def getCount
    @data.size
  end

  def getItem(pos:int)
    @data.get pos
  end

  def getItemId(pos:int)
    NearbyWikipediaEntry(getItem pos).id
  end

  def getView(pos:int, convert:View, parent:ViewGroup)
    views = LinearLayout(convert)
    if convert.nil?
      views = LinearLayout(@inflater.inflate R.layout.list_item, parent, false)
    end

    entry = NearbyWikipediaEntry(getItem pos)
    text = TextView(views.getChildAt 0)
    dist = TextView(views.getChildAt 1)

    text.setText entry.title
    dist.setText String.format('About %.2fm away', [entry.distance].toArray)

    View(views)
  end
  
end
