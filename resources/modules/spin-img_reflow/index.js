'use strict'

import $ from 'jquery'
import { sprintf } from 'sprintf-js'

/**
 * @type {string}
 */
const stylePattern = '<div style="padding-bottom: %s%%">'

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
 * Apply aspect ratio.
 *
 * @param {jQuery} $image
 * @param {number} height
 * @param {number} width
 */
let apply = function ($image, height, width) {
  return $image
    .wrap(sprintf(stylePattern, calc(height, width)))
    .css('position', 'absolute')
}

export default function () {
  $(function () {
    $('img[height][width]').each(function () {
      let $image = $(this)
      let height = parseInt($image.attr('height'), 10)
      let width = parseInt($image.attr('width'), 10)

      if (height && width) {
        apply($image, height, width)
      }
    })
  })
}
