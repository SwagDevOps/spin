'use strict'

import MdEditor from './editor.vue'

export default {
  install (Vue) {
    Vue.component('MdEditor', MdEditor)
  }
}

export { MdEditor }
