'use strict'

import Buefy from 'buefy'
import VueProgressiveImage from 'vue-progressive-image'

import { Appifier } from '@swagdevops/vue-appifier'
import { MdEditor } from 'spin-md_editor'

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
