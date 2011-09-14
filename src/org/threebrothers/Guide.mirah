package org.threebrothers

import android.app.Activity

import android.view.View

import android.widget.Button
import android.widget.Button
import android.widget.TextView
import android.widget.Toast

class Guide < Activity
  
  def onCreate(state)
    super state
    setContentView R.layout.guide

    this = self # scoping
    
    @locate_btn = Button(findViewById R.id.locate_btn)
    @locate_btn.setOnClickListener do |v|
      this.update_location(v)
      # Toast.makeText(this, 'Fire ze missiles!', Toast.LENGTH_SHORT).show
    end

    @current_location = TextView(findViewById R.id.current_location)
  end

  def update_location(v:View)
    @current_location.setText 'Fire ze missiles!'
  end
  
end
