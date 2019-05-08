'use strict'

import Vue from 'vue'
import Tabs from 'buefy/dist/components/tabs'

import cuid from 'cuid'
import Editor from './editor.vue'

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
  Vue.component('md-editor', Editor)

  _vue({ el: `#${id}` })
}

/**
 * Install editors for given class name ``cname``.
 *
 * @param {String} cname
 */
const installEditors = function (cname) {
  Array.from(document.getElementsByClassName(cname)).forEach(function (element) {
    let id = element.getAttribute('id') || cuid()

    element.setAttribute('id', id)

    installEditor(id)
  })
}

// exports ----------------------------------------------------------

export { installEditors, installEditor }

export default function () {
  window.addEventListener('DOMContentLoaded', () => installEditors(cname))
}
