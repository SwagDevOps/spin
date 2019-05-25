'use strict'

import { Layout } from './app/layout'
import { Appifier } from './app/appifier'
import Buefy from 'buefy'
import MdEditor from 'spin-md_editor/plugin'
import VueProgressiveImage from 'vue-progressive-image'

(new Appifier({
  plugins: [
    [Buefy],
    [MdEditor],
    [VueProgressiveImage, {
      cache: false,
      blur: 30
    }]
  ]
})).appify()

Layout.install()
