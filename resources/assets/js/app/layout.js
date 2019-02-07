'use strict'

import $ from 'jquery'
import imageReflow from './layout/img_reflow'
import mdl from 'encapsulated-mdl'
import alert from 'md-alerts'

// expose jQuery to window ------------------------------------------
if (typeof window !== 'undefined') {
  window.jQuery = $
  window.$ = $
}

export default function () {
  $(function () {
    upgradeDom()
    alert()
    imageReflow()
  })
}

let upgradeDom = function () {
  upgradeJsElements()

  mdl.componentHandler.upgradeDom()
}

/**
 * @see https://github.com/google/material-design-lite/issues/246
 */
let upgradeJsElements = function () {
  ['textfield', 'button'].forEach(function (type) {
    $('.mdl-' + type).each(function () {
      let $element = $(this)

      $element.addClass('mdl-js-' + type)
    })
  })
}
