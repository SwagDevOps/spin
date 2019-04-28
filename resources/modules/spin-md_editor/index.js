'use strict'

import Vue from 'vue'
import Tabs from 'buefy/dist/components/tabs'

import cuid from 'cuid'
import * as marked from 'marked'
import * as _ from 'lodash'

/**
 * Class used to recognize markdown editors.
 *
 * @type {string}
 */
const cname = 'is-md_editor'

/**
 * @private
 *
 * @param {object} c
 * @returns {Vue | CombinedVueInstance<Vue, object, object, object, Record<never, any>>}
 */
const _vue = function (c) {
  Vue.use(Tabs)

  let vue = (c) => new Vue(c)

  return vue(c)
}

/**
 * Install an individual editor.
 *
 * @param {String} id
 */
const installEditor = function (id) {
  _vue({
    el: `#${id}`,
    data: {
      input: '',
      activeTab: 0,
      showBooks: false
    },
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

/**
 * Install editors for given class name ``cname``.
 *
 * @param {String} cname
 */
const installEditors = function (cname) {
  Array.from(document.getElementsByClassName(cname)).forEach(function (element) {
    let id = `${cname}_${cuid()}`

    element.setAttribute('id', id)

    installEditor(id)
  })
}

// exports ----------------------------------------------------------

export { installEditors, installEditor }

export default function () {
  window.addEventListener('DOMContentLoaded', () => installEditors(cname))
}
