'use strict'

import Vue from 'vue'
import Vuex from 'vuex'

/**
 * Install Vue app.
 *
 * Sample of use:
 *
 * ```
 * import { Appifier } from '@swagdevops/vue-appifier'
 * import Buefy from 'buefy'
 * import VueLazyload from 'vue-lazyload'
 *
 * (new Appifier({
 *   plugins: [
 *     Buefy,
 *     [VueLazyload, {
 *       preLoad: 1.3,
 *       error: 'dist/error.png',
 *       loading: 'dist/loading.gif',
 *       attempt: 1
 *    }]
 *   ]
 * })).appify()
 * ```
 */
class Appifier {
  /**
   * @param {Object} config
   */
  constructor (config = {}) {
    Vue.use(Vuex)
    this._defaults = {
      id: 'app',
      plugins: [],
      components: {},
      store: new Vuex.Store({
        state: {}
      })
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
    return this.apply()
  }

  /**
   * Install a Vue app on given id.
   *
   * @returns {Appifier}
   */
  apply () {
    let event = 'DOMContentLoaded'
    let vue = (id) => new Vue({
      el: `#${id}`
    })

    this.config.plugins.forEach(function (plugin) {
      plugin = Array.isArray(plugin) ? plugin : [plugin]

      Vue.use(...plugin)
    })

    Object.entries(this.config.components).forEach(function (i) {
      Vue.component(i[0], i[1])
    })

    window.addEventListener(event, () => vue(this.config.id))

    return this
  }
}

export { Appifier }
