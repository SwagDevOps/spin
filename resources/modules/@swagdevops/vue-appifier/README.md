# Vue Appifier

## Simply install a Vue app (from scratch)

Sample of use:

```js
import { Appifier } from '@swagdevops/vue-appifier'
import Buefy from 'buefy'
import VueLazyload from 'vue-lazyload'

(new Appifier({
  plugins: [
    Buefy,
    [VueLazyload, {
      preLoad: 1.3,
      error: 'dist/error.png',
      loading: 'dist/loading.gif',
      attempt: 1
    }]
  ]
})).appify()
```
