package org.threebrothers

import android.app.Activity

import android.widget.Button
import android.widget.Toast

class Guide < Activity
  
  def onCreate(state)
    super state
    setContentView R.layout.guide

    this = self

    @locate_btn = Button(findViewById R.id.locate_btn)
    @locate_btn.setOnClickListener do |v|
      Toast.makeText(this, 'Fire ze missiles!', Toast.LENGTH_SHORT).show
    end
  end
  
end
