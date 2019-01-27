'use strict'

// import 'bootstrap/js/src/alert'
// import 'bootstrap/js/src/button'

import ch from 'material-design-lite/material'
import wow from './layout/wow'
import imagesReflow from './layout/img_reflow'

export default function () {
  ch.upgradeDom()

  imagesReflow()
  wow()
}
