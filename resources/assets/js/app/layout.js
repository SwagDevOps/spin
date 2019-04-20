'use strict'

import $ from 'jquery'
import imageReflow from './layout/img_reflow'
import alert from 'md-alerts'

// expose jQuery to window ------------------------------------------
if (typeof window !== 'undefined') {
  window.jQuery = $
  window.$ = $
}

export default function () {
  $(function () {
    alert()
    imageReflow()
  })
}
