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

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.util.Log
import android.widget.Button
import android.widget.TextView


class Detail < Activity

  def onCreate(state)
    super state
    setContentView R.layout.detail

    this = self
    intent = getIntent
    unless intent.nil?
      title_view = TextView(findViewById R.id.detail_title)
      summary_view = TextView(findViewById R.id.detail_summary)
      wikipedia_btn = Button(findViewById R.id.detail_wikipedia_btn)
      map_btn = Button(findViewById R.id.detail_map_btn)

      title_view.setText intent.getStringExtra('title')
      summary_view.setText intent.getStringExtra('summary')
      
      wikipedia_btn.setOnClickListener do |v|
        uri = Uri.parse(intent.getStringExtra 'url')
        this.startActivity Intent.new(Intent.ACTION_VIEW, uri)
      end

      map_btn.setOnClickListener do |v|
        modified_title = intent.getStringExtra('title')
        modified_title = modified_title.split('\\(')[0]
        uri = Uri.parse(String.format 'geo:0,0?q=%f,%f (%s)',
                        [intent.getFloatExtra('latitude', float(0.0)),
                         intent.getFloatExtra('longitude', float(0.0)),
                         Uri.encode(modified_title)].toArray)
        Log.d 'Detail', "#{uri}"
        this.startActivity Intent.new(Intent.ACTION_VIEW, uri)
      end
    end
  end
  
end
