'use strict'

import { Layout } from './app/layout'
import { Appifier } from './app/appifier'
import Buefy from 'buefy'
import MdEditor from 'spin-md_editor/plugin'

(new Appifier({
  plugins: [Buefy, MdEditor]
})).appify()

Layout.install()
