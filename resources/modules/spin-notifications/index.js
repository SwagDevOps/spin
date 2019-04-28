'use strict'

import $ from 'jquery'

/**
 * Handle click on trigger.
 *
 * @param {jQuery} $trigger
 * @param {jQuery} $container
 */
const handleDeleteClick = function ($trigger, $container = null) {
  let $notification = $trigger.parent()

  $notification.remove()
  if (!$container) {
    return
  }

  if ($container.children().length < 1) {
    $container.remove()
  }
}

/**
 * @param {String} trigger
 * @param {String} container
 */
export default function (trigger = '.notification .delete', container = null) {
  $(function () {
    let $trigger = $(trigger)
    let $container = container ? $(container) : null

    $trigger.click(function (e) {
      e.preventDefault()

      handleDeleteClick($(this), $container)
    })
  })
}
