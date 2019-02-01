'use strict'

import $ from 'jquery'
import imageReflow from './layout/img_reflow'

// expose jQuery to window ------------------------------------------
if (typeof window !== 'undefined') {
  window.jQuery = $
  window.$ = $
}

export default function () {
  $(function () {
    require('material-design-lite/material')

    imageReflow()
  })
}
