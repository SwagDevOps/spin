'use strict'

import Vue from 'vue'
import MdEditor from 'spin-md_editor/plugin'

import imageReflow from 'spin-img_reflow'
import notificationClickHandler from 'spin-notifications'

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
class Layout {
  constructor () {
    this.selectors = {
      app: '#app',
      notification_container: '#notifications',
      notification_delete: '.notification .delete'
    }
  }

  /**
   * @returns {this}
   */
  install () {
    Vue.use(MdEditor)

    return this
      ._vue({ el: this.selectors.app })
      .handleNotifications()
      .imageReflow()
  }

  static install () {
    return (new this()).install()
  }

  _vue (c) {
    let vue = (c) => new Vue(c)

    window.addEventListener('DOMContentLoaded', () => vue(c))

    return this
  }

  /**
   * @returns {this}
   */
  imageReflow () {
    imageReflow()

    return this
  }

  /**
   * @returns {this}
   *
   * @see https://bulma.io/documentation/elements/notification/
   */
  handleNotifications () {
    let container = this.selectors.notification_container
    let trigger = this.selectors.notification_container
      ? `${this.selectors.notification_container} ${this.selectors.notification_delete}`
      : this.selectors.notification_delete

    notificationClickHandler(trigger, container)

    return this
  }
}

export { Layout }
