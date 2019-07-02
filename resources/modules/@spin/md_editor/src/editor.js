'use strict'

import Vue from 'vue'
import Tabs from 'buefy/dist/components/tabs'
import * as marked from 'marked'
import * as _ from 'lodash'

Vue.use(Tabs)

export default {
  template: '#editor',
  data: function () {
    return {
      activeTab: 0
    }
  },
  props: {
    value: {
      type: String,
      required: false
    },
    name: {
      type: String,
      required: true
    }
  },
  computed: {
    preview: function () {
      return marked(this.value, { sanitize: true })
    }
  },
  methods: {
    update: _.debounce(function (e) {
      this.value = e.target.value
    }, 300)
  }
}
