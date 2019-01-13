'use strict'

import $ from 'jquery'
import { sprintf } from 'sprintf-js'

/**
 * Calculate aspect ratio.
 *
 * @param {number} height
 * @param {number} width
 *
 * @returns {number}
 */
let calc = function (height, width) {
  return height / width * 100
}

/**
 * @type {string}
 */
const stylePattern = '<div style="padding-bottom: %s%%; display: inline-block">'

/**
 * Apply aspect ratio.
 *
 * @param {jQuery} $image
 * @param {number} height
 * @param {number} width
 */
let apply = function ($image, height, width) {
  $image.memento = $image.attr('src')

  $.ajax({
    url: $image.memento,
    cache: true,
    crossDomain: true,
    method: 'HEAD',
    context: document.body,
    beforeSend: function () {
      $image
        .wrap(sprintf(stylePattern, calc(height, width)))
        .css('position', 'absolute')
    }
  }).always(function () {
    $image
      .attr('src', $image.memento)
      .show()
  })
}

export default function () {
  $(function () {
    $('img[height][width]').hide().each(function () {
      let $image = $(this)
      let height = parseInt($image.attr('height'), 10)
      let width = parseInt($image.attr('width'), 10)

      if (height && width) {
        apply($image, height, width)
      }
    })
  })
}
