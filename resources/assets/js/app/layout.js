'use strict'

import imageReflow from 'spin-img_reflow'
import { Bulma } from '../bulma'

const bulmaInstall = function () {
  let bulma = new Bulma()

  bulma
    .handleNotifications()
}

export default function () {
  bulmaInstall()
  imageReflow()
}
