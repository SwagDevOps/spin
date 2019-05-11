'use strict'

import Navigo from 'navigo'
import layout from './app/layout'
import mde from 'spin-md_editor'

const router = new Navigo(null, false, '#')

router
  .on(() => layout())
  .on({
    '/pages/editor': () => mde()
  })
  .resolve()
