'use strict'

/**
 * Wrapper built on top of foundation.
 *
 * @see https://github.com/zurb/foundation-sites/issues/7386#issuecomment-337140379
 */
import $ from 'jquery'
import { Foundation } from 'foundation-sites/js/foundation.core'
import { Box } from 'foundation-sites/js/foundation.util.box'
import { Tooltip } from 'foundation-sites/js/foundation.tooltip'
import { Sticky } from 'foundation-sites/js/foundation.sticky'
import { Reveal } from 'foundation-sites/js/foundation.reveal'

const jQuery = $

export default function () {
  Foundation.addToJquery(jQuery)
  Foundation.Box = Box

  $(function () {
    Foundation.plugin(Tooltip, 'Tooltip')
    Foundation.plugin(Sticky, 'Sticky')
    Foundation.plugin(Reveal, 'Reveal')

    $(document).foundation()
  })
}
