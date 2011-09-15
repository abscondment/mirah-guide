package org.threebrothers

import android.app.Activity
import android.content.Intent
import android.util.Log

import android.view.View
import android.widget.Button
import android.widget.ListView
import android.widget.TextView
import android.widget.Toast

import android.location.Location

import android.os.Handler
import android.os.Message

import org.json.JSONObject

class Guide < Activity
  
  def onCreate(state)
    super state
    setContentView R.layout.guide

    this = self # scoping
    
    @locator = Locator.new self
    @current_location = TextView(findViewById R.id.current_location)

    @locate_btn = Button(findViewById R.id.locate_btn)
    @locate_btn.setOnClickListener do |v|
      this.update_location
    end
    
    @list = ListView(findViewById R.id.list)
    @adapter = NearbyWikipediaAdapter.new self
    @list.setAdapter @adapter
    @list.setOnItemClickListener do |parent, view, pos, id|
      entry = NearbyWikipediaEntry(parent.getItemAtPosition pos)
      intent = Intent.new(this, Detail.class)
      
      intent.putExtra 'title', entry.title
      intent.putExtra 'summary', entry.summary
      intent.putExtra 'url', entry.url
      intent.putExtra 'latitude', entry.latitude
      intent.putExtra 'longitude', entry.longitude
      
      this.startActivity intent
    end
  end

  def onStart
    super
    update_location
  end

  def onStop
    super
    @locator.stop
  end

  def update_location
    @locator.start
  end

  def use_location(loc:Location)
    unless loc.nil?
      @current_location.setText String.format('%.2f,%.2f (%.1f)', [loc.getLatitude,
                                                                   loc.getLongitude,
                                                                   loc.getAccuracy].toArray)
      adapter = @adapter
      handler = Handler.new do |message|
        if message.what == 200
          adapter.json = JSONObject(message.obj)
        end
        true
      end

      
      t = Thread.new do
        # fetch list for this location
        json = GeoNamesClient.get.find_nearby_wikipedia_json loc
        Log.d 'Guide', "got json: #{json}"
        message = handler.obtainMessage 200, json
        handler.sendMessage message
      end
      t.start
    end
  end
  
end
