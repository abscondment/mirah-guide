package org.threebrothers

import android.app.Activity

class Guide < Activity
  def onCreate(state)
    super state
    setContentView R.layout.guide
  end
end
