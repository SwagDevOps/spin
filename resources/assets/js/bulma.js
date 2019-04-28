'use strict'

import notificationClickHandler from 'spin-notifications'

class Bulma {
  constructor () {
    this.selectors = {
      notification_container: '#notifications',
      notification_delete: '.notification .delete'
    }
  }

  /**
   * @returns {Bulma}
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

export { Bulma }
