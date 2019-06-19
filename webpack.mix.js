'use strict'

/* global require */
const { Mixer } = require('@swagdevops/webpack-mixer')
const mixer = new Mixer()
const paths = mixer.paths

// Configuration ----------------------------------------------------

const copiables = [
  [paths.source.join('images/favicon.png'), paths.public.join('favicon.ico')],
  [paths.source.join('images/**/*'), paths.public.join('images')]
]
  .concat(paths.vendor.join('material-icons/iconfont').glob([
    '*.eot', '*.svg', '*.ttf', '*.woff', '*.woff2'
  ]).map(fp => [fp, paths.public.join('fonts')]))
  .concat(paths.vendor.join('roboto-npm-webfont/full/fonts').glob('*')
    .map(fp => [fp, paths.public.join('fonts')]))
  .concat(paths.vendor.join('@mdi/font/fonts').glob('*')
    .map(fp => [fp, paths.public.join('fonts')]))

const cleanables = []
  .concat(paths.public.join('css').glob('*.map'))
  .concat(paths.public.join('js').glob('*.map'))

// Execution --------------------------------------------------------

mixer.configure({
  copiables,
  cleanables,
  webpack: {
    node: {
      fs: 'empty'
    }
  }
}).run()
