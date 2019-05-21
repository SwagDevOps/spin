'use strict'

import Vue from 'vue'

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
      notification_container: '#notifications',
      notification_delete: '.notification .delete'
    }
  }

  /**
   * @returns {this}
   */
  install () {
    return this
      .handleNotifications()
      .imageReflow()
  }

  static install () {
    return (new this()).install()
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
