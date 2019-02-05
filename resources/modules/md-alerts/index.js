import $ from 'jquery'

/**
 * Scan for matching class.
 *
 * @param {jQuery} $container
 * @param {string} cssClass
 * @returns {*}
 */
const scan = function ($container, cssClass = 'alert') {
  return $container.children().toArray().map(function (el) {
    let $el = $(el)

    if ($el.length > 0) {
      return $el.hasClass(cssClass)
    }
  })
}

/**
 * Handle click on trigger.
 *
 * @param {jQuery} $trigger
 */
const handleClick = function ($trigger) {
  let $alert = $trigger.parent()
  let $container = $alert.parent()
  let scanResult = scan($container)

  $alert.remove()

  if (scanResult.every(x => x === true) && $container.children().length < 1) {
    $container.remove()
  }
}

export default function () {
  $(function () {
    $('.alert .close').click(function (e) {
      e.preventDefault()

      handleClick($(this))
    })
  })
}
