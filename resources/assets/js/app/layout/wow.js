'use strict'

import $ from 'jquery'
import { WOW as BaseWOW } from 'wowjs'

/**
 * Config used to initialize WOW.
 *
 * @type {{live: boolean}}
 */
const config = {
  live: false // https://github.com/matthieua/WOW/issues/166
}

/**
 * Singleton on top of WOW.
 *
 * @type {{getInstance: (function(): BaseWOW)}}
 * @see https://wowjs.uk/
 * @see https://github.com/matthieua/WOW
 */
const WOW = {
  _instance: null,
  /**
   * Get an actual instance.
   *
   * @returns {BaseWOW}
   */
  getInstance: function () {
    this._instance = this._instance || new BaseWOW(config)

    return this._instance
  }
}

export default function () {
  $(function () {
    WOW.getInstance().init()
  })
}

export { WOW }
