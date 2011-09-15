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
        uri = Uri.parse(String.format 'geo:0,0?q=%f,%f (%s)',
                        [intent.getFloatExtra('latitude', float(0.0)),
                         intent.getFloatExtra('longitude', float(0.0)),
                         Uri.encode(intent.getStringExtra('title'))].toArray)
        Log.d 'Detail', "#{uri}"
        this.startActivity Intent.new(Intent.ACTION_VIEW, uri)
      end
    end
  end
  
end
