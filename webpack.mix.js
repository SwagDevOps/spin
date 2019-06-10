'use strict'

/* global process, require, __dirname */

const { Mixer } = require('@swagdevops/webpack-mixer')

let m = new Mixer()

// Configuration ----------------------------------------------------

/**
 * Copiables
 *
 * @type {*[]}
 */
const copiables = [
  [m.paths.source.join('images/favicon.png'), m.paths.public.join('favicon.ico')],
  [m.paths.source.join('images'), m.paths.public.join('images')]
]
  .concat(['eot', 'svg', 'ttf', 'woff', 'woff2']
    .map(ext => m.paths.vendor.join('material-icons/iconfont/*.%s').format(ext).glob())
    .reduce((acc, val) => acc.concat(val), []) // flat()
    .map(fp => [fp, m.paths.public.join('fonts')])
  )
  .concat(m.paths.vendor.join('roboto-npm-webfont/full/fonts/*')
    .glob()
    .map(fp => [fp, m.paths.public.join('fonts')]))
  .concat(m.paths.vendor.join('@mdi/font/fonts/*')
    .glob()
    .map(fp => [fp, m.paths.public.join('fonts')]))

/**
 * Cleanables
 *
 * @type {Path[]}
 */ // @formatter:off
let cleanables = ([
  m.paths.public.join('css/*.map'),
  m.paths.public.join('js/*.map')
]
  .map(fp => fp.glob())
  .reduce((acc, val) => acc.concat(val), [])
  // @formatter:on
)
  .concat(copiables.map(x => x[1]))
  .filter((x, i, a) => a.indexOf(x) === i)
  .sort(function (a, b) { return a.localeCompare(b) })

// Execution --------------------------------------------------------

m.configure({
  copiables: copiables,
  cleanables: cleanables,
  webpack: {
    node: {
      fs: 'empty'
    }
  }
}).run()
