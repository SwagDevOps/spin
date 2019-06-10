'use strict'

/* global process, require, __dirname */

const { Mixer } = require('@swagdevops/webpack-mixer')

const mixer = new Mixer()

/**
 * @type {*}
 */
const paths = mixer.paths

// Configuration ----------------------------------------------------

/**
 * Copiables
 *
 * @type {*[]}
 */
const copiables = [
  [paths.source.join('images/favicon.png'), paths.public.join('favicon.ico')],
  [paths.source.join('images'), paths.public.join('images')]
]
  .concat(['eot', 'svg', 'ttf', 'woff', 'woff2']
    .map(ext => paths.vendor.join('material-icons/iconfont/*.%s').format(ext).glob())
    .reduce((acc, val) => acc.concat(val), []) // flat()
    .map(fp => [fp, paths.public.join('fonts')])
  )
  .concat(paths.vendor.join('roboto-npm-webfont/full/fonts/*')
    .glob()
    .map(fp => [fp, paths.public.join('fonts')]))
  .concat(paths.vendor.join('@mdi/font/fonts/*')
    .glob()
    .map(fp => [fp, paths.public.join('fonts')]))

/**
 * Cleanables
 *
 * @type {Path[]}
 */ // @formatter:off
const cleanables = ([
  paths.public.join('css/*.map'),
  paths.public.join('js/*.map')
]
  .map(fp => fp.glob())
  .reduce((acc, val) => acc.concat(val), [])
  // @formatter:on
)
  .concat(copiables.map(x => x[1]))
  .filter((x, i, a) => a.indexOf(x) === i)
  .sort(function (a, b) { return a.localeCompare(b) })

// Execution --------------------------------------------------------

mixer.configure({
  copiables: copiables,
  cleanables: cleanables,
  webpack: {
    node: {
      fs: 'empty'
    }
  }
}).run()
