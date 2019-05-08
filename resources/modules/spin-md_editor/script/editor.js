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
      name: '',
      input: '',
      activeTab: 0
    }
  },
  mounted: function () {
    this.input = this.$el.attributes.value.value
    this.name = this.$el.attributes.name.value
  },
  computed: {
    preview: function () {
      return marked(this.input, { sanitize: true })
    }
  },
  methods: {
    update: _.debounce(function (e) {
      this.input = e.target.value
    }, 300)
  }
}