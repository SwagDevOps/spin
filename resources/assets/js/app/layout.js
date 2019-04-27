'use strict'

import $ from 'jquery'
import imageReflow from './layout/img_reflow'
import { Bulma } from '../bulma'

// expose jQuery to window ------------------------------------------
if (typeof window !== 'undefined') {
  window.jQuery = $
  window.$ = $
}

const bulmaInstall = function () {
  let bulma = new Bulma()

  bulma
    .handleNotifications()
}

export default function () {
  bulmaInstall()
  imageReflow()
}
