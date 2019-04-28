'use strict'

import Vue from 'vue'
import * as marked from 'marked'
import * as _ from 'lodash'

const vue = function (c) {
  let vue = (c) => new Vue(c)

  window.addEventListener('load', () => vue(c))
}

export default function () {
  vue({
    el: '#editor',
    data: { input: '' },
    mounted () {
      this.input = this.$refs.value.dataset.value
    },
    computed: {
      compiledMarkdown: function () {
        return marked(this.input, { sanitize: true })
      }
    },
    methods: {
      update: _.debounce(function (e) {
        this.input = e.target.value
      }, 300)
    }
  })
}
