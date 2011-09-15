package org.threebrothers

import android.app.Activity
import android.util.Log

import android.view.View
import android.widget.Button
import android.widget.Button
import android.widget.TextView
import android.widget.Toast

import android.location.Location

class Guide < Activity
  
  def onCreate(state)
    super state
    setContentView R.layout.guide

    this = self # scoping
    
    @locate_btn = Button(findViewById R.id.locate_btn)
    @locate_btn.setOnClickListener do |v|
      this.update_location
    end

    @current_location = TextView(findViewById R.id.current_location)

    @locator = Locator.new self
  end

  def onResume
    super
    update_location
  end

  def onPause
    super
    @locator.stop
  end

  def update_location
    @locator.start
  end

  def use_location(loc:Location)
    @current_location.setText String.format('%.2f,%.2f (%.1f)', [loc.getLatitude,
                                                                 loc.getLongitude,
                                                                 loc.getAccuracy].toArray)
    t = Thread.new do
      # fetch list for this location
      json = GeoNamesClient.get.find_nearby_wikipedia_json loc
      Log.d 'Guide', "got json: #{json}"
    end
    t.start
  end
end
