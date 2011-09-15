package org.threebrothers

import android.app.Activity
import android.content.Intent
import android.util.Log

import android.app.ProgressDialog
import android.view.View
import android.widget.Button
import android.widget.ListView
import android.widget.TextView

import android.location.Location

import android.os.Handler
import android.os.Message

import org.json.JSONObject

class Guide < Activity
  
  def onCreate(state)
    super state
    setContentView R.layout.guide

    this = self # scoping
    
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

    @locator = Locator.new self
    start_locating
  end

  def onStop
    super
    stop_locating
  end

  def onCreateOptionsMenu(menu)
    getMenuInflater.inflate(R.menu.menu, menu)
    true
  end

  def onOptionsItemSelected(item)
    if item.getItemId == R.id.start_locating
      start_locating
      true
    else
      super item
    end
  end

  def use_location(loc:Location)
    unless loc.nil?
      this = self # scoping
      adapter = @adapter # scoping
      handler = Handler.new do |message|
        if message.what == 200
          adapter.json = JSONObject(message.obj)
          this.stop_locating
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

  def start_locating
    @spinner.dismiss unless @spinner.nil?
    @spinner = ProgressDialog.show self, String(nil), 'Loading...'
    @locator.start
  end

  def stop_locating
    @locator.stop
    @spinner.dismiss unless @spinner.nil?
  end
  
end
