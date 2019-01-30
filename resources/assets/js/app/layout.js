'use strict'

// import 'bootstrap/js/src/alert'
// import 'bootstrap/js/src/button'

import $ from 'jquery'
import mdl from 'material-design-lite/material'
import wow from './layout/wow'
import imagesReflow from './layout/img_reflow'

export default function () {
  $(function () {
    mdl.upgradeDom()
    imagesReflow()
    wow()
  })
}
