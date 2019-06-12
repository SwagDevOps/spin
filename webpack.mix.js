'use strict'

/* global process, require, __dirname */

const { Mixer } = require('@swagdevops/webpack-mixer')

const mixer = new Mixer()
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
  .concat(['*.eot', '*.svg', '*.ttf', '*.woff', '*.woff2']
    .map(pattern => paths.vendor.join('material-icons/iconfont').glob(pattern))
    .reduce((acc, val) => acc.concat(val), []) // flat()
    .map(fp => [fp, paths.public.join('fonts')])
  )
  .concat(paths.vendor.join('roboto-npm-webfont/full/fonts').glob('*')
    .map(fp => [fp, paths.public.join('fonts')]))
  .concat(paths.vendor.join('@mdi/font/fonts').glob('*')
    .map(fp => [fp, paths.public.join('fonts')]))

/**
 * Cleanables
 *
 * @type {Path[]}
 */ // @formatter:off
const cleanables = ([
  paths.public.join('css').glob('*.map'),
  paths.public.join('js').glob('*.map')
]
  .reduce((acc, val) => acc.concat(val), []) // flat
  // @formatter:on
)
  .concat(copiables.map(x => x[1]))

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
