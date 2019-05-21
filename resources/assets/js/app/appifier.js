'use strict'

import Vue from 'vue'

/**
 * Install layout.
 *
 * Sample of use:
 *
 * ```
 * import { Layout } from './app/layout'
 *
 * Layout.install()
 * ```
 */
class Appifier {
  /**
   * @param {Object} config
   */
  constructor (config = {}) {
    this._defaults = {
      id: 'app',
      plugins: [],
      components: {}
    }
    this._config = Object.assign({}, this._defaults)

    Object.assign(this._config, config)
  }

  /**
   * Get config
   *
   * @returns {any | ({} & {components: {}, plugins: Array, id: string})}
   */
  get config () {
    return Object.assign({}, this._config)
  }

  /**
   * @returns {Appifier}
   */
  appify () {
    return this._apply()
  }

  /**
   * Install a Vue app on given id.
   *
   * @param {String} id
   * @returns {Appifier}
   */
  _apply () {
    let event = 'DOMContentLoaded'
    let vue = (id) => new Vue({
      el: `#${id}`
    })

    this.config.plugins.forEach((plugin) => Vue.use(plugin))
    Object.entries(this.config.components).forEach(function (i) {
      Vue.component(i[0], i[1])
    })

    window.addEventListener(event, () => vue(this.config.id))

    return this
  }
}

export { Appifier }
