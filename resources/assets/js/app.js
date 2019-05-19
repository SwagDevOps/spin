'use strict'

import Navigo from 'navigo'
import { Layout } from './app/layout'

const router = new Navigo(null, false, '#')

router
  .on(() => Layout.install())
  // .on({
  //   '/pages/editor': () => mde()
  // })
  .resolve()
