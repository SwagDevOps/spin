'use strict'

/**
 * Wrapper built on top of foundation.
 *
 * @see https://github.com/zurb/foundation-sites/issues/7386#issuecomment-337140379
 */
import $ from 'jquery'
import { Foundation } from 'foundation-sites/js/foundation.core'

let load = function () {
  window.$ = window.jQuery = $
  Foundation.addToJquery($)
}

export default function () {
  load()

  $(function () {
    $(document).foundation()
  })
}
