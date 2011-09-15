package org.threebrothers

import android.content.Context
import android.os.Bundle
import android.os.Looper
import android.util.Log

# GPS access
import android.location.Criteria
import android.location.LocationManager
import android.location.LocationListener
import android.location.Location

class Locator
  implements LocationListener

  def initialize(guide:Guide)
    @locating = false
    @guide = guide
    @manager = LocationManager(Context(@guide).getSystemService(Context.LOCATION_SERVICE))

    @update_interval_hint = long(60_000) # how often do we suggest polling?
    @min_distance = 10 # how close is close enough?
    @max_distance = 1000 # how far do we let you move before refreshing?
  end

  def start:void
    if @locating
      return
    else
      @locating = true
    end
    
    #
    # begin with the most recent location
    #
    if @location.nil?
      loc = (@manager.getLastKnownLocation(LocationManager.GPS_PROVIDER) || @manager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER))
      onLocationChanged loc unless loc.nil?
    end

    #
    # register for updates
    #

    @manager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER,
                                    @update_interval_hint, @min_distance, self)
    @manager.requestLocationUpdates(LocationManager.GPS_PROVIDER,
                                    @update_interval_hint, @min_distance, self)
  end

  def stop
    @manager.removeUpdates(self)
    @locating = false
  end

  def onLocationChanged(loc:Location)
    skip_update = false
    
    unless @location.nil?      
      # ignore if new location hasn't changed much
      if @location.distanceTo(loc) <= @max_distance

        # still close and accuracy is worse - ignore altogether
        if (!loc.hasAccuracy) || (@location.hasAccuracy && @location.getAccuracy < loc.getAccuracy)
          Log.d tag(), "ignoring location: within max_distance of current and of worse accuracy"
          return
        else
          # we just haven't moved enough - save it, but don't refresh the guide
          Log.d tag(), "skipping update: within max_distance of current"
          skip_update = true
        end
      end
    end
    
    Log.d tag(), "new location: #{loc.getLatitude}, #{loc.getLongitude}; accuracy: #{loc.getAccuracy}"
    @location = loc
    @guide.use_location @location unless skip_update
  end

  # We don't really care about provider-specific things
  def onProviderEnabled(provider); end
  def onProviderDisabled(provider); end
  def onStatusChanged(provider:String, status:int, extras:Bundle); end

  protected

  def tag
    self.getClass.getSimpleName
  end
end
