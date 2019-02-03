'use strict'

import $ from 'jquery'
import imageReflow from './layout/img_reflow'
import mdl from 'encapsulated-mdl'

// expose jQuery to window ------------------------------------------
if (typeof window !== 'undefined') {
  window.jQuery = $
  window.$ = $
}

export default function () {
  $(function () {
    mdl.componentHandler.upgradeDom()

    imageReflow()
  })
}
