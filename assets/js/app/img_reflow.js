'use strict'

import $ from 'jquery'
import { sprintf } from 'sprintf-js'

/**
 * Calculate aspect ratio.
 *
 * @param {number} height
 * @param {number} width
 * @returns {number}
 */
let calc = function (height, width) {
  return height / width * 100
}

/**
 * @type {string}
 */
const stylePattern = '<div style="display: block; position: relative; padding-bottom: %s%%">'

export default function () {
  $(function () {
    $('img').each(function () {
      let $image = $(this)
      let height = $image.attr('height')
      let width = $image.attr('width')

      if (height && width) {
        $image.memento = $image.attr('src')

        $.ajax({
          url: $image.memento,
          cache: true,
          crossDomain: true,
          method: 'HEAD',
          context: document.body,
          beforeSend: function () {
            $image
              .hide()
              .bind('load', function () { $image.show() })
              .wrap(sprintf(stylePattern, calc(height, width)))
              .css('position', 'absolute')
          }
        }).always(function () {
          $image.attr('src', $image.memento).show()
        })
      }
    })
  })
}
