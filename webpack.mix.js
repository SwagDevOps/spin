'use strict'

/* global process, require, path, __dirname */

const Mix = require('webpack-mix')
const glob = require('simple-glob')
const sprintf = require('sprintf-js').sprintf
const Clean = require('clean-webpack-plugin')
const ExtraWatchWebpackPlugin = require('extra-watch-webpack-plugin')
const VersionFile = require('webpack-version-file-plugin')
const moduleRoots = (require(path.join(__dirname, 'package.json')).moduleRoots || [])
  .concat(['node_modules'])
  .map(fp => path.join(__dirname, fp) + '/')
  .filter((x, i, a) => a.indexOf(x) === i)

/*
 |--------------------------------------------------------------------------
 | Mix Asset Management
 |--------------------------------------------------------------------------
 |
 | Mix provides a clean, fluent API for defining some Webpack build steps
 | for your application. By default, we are compiling the Sass
 | file for the application as well as bundling up all the JS files.
 |
 */
const mix = function () {
  let mix = Mix.webpackConfig(config)

  copiables.forEach(copiable => mix.copy(copiable[0], copiable[1], false))

  mix.js(path.join(_paths.source, 'js/app.js'), paths.js)
  mix.sass(path.join(_paths.source, 'sass/app.scss'), paths.css, {
    sourceComments: !mix.config.production,
    includePaths: moduleRoots
  })

  mix.sourceMaps()
}

/**
 * Internal paths
 *
 * @private
 * @type {{public: (string), source: (string), vendor: (string)}}
 */
const _paths = {
  vendor: path.join(__dirname, 'node_modules'),
  source: path.join(__dirname, 'resources/assets'),
  public: path.join(__dirname, 'public')
}

/**
 * Public paths
 *
 * @type {{css: (string), images: (string), fonts: (string), root, js: (string)}}
 */
const paths = {
  root: _paths.public,
  js: path.join(_paths.public, 'js'),
  css: path.join(_paths.public, 'css'),
  fonts: path.join(_paths.public, 'fonts'),
  images: path.join(_paths.public, 'images')
}

/**
 * Copiables
 *
 * @type {*[]}
 */
const copiables = [
  [path.join(_paths.source, 'images/favicon.png'), path.join(paths.root, 'favicon.ico')],
  [path.join(_paths.source, 'images'), paths.images]
]
// specific ---------------------------------------------------------
  .concat(glob(['eot', 'svg', 'ttf', 'woff', 'woff2']
    .map(ext => sprintf(path.join(_paths.vendor, 'material-icons/iconfont/*.%s'), ext)))
    .map(fp => [fp, paths.fonts]))
  .concat(glob(path.join(_paths.vendor, 'roboto-npm-webfont/full/fonts/*'))
    .map(fp => [fp, paths.fonts]))
  .concat([[
    path.join(_paths.vendor, '@mdi/font/fonts'),
    path.join(paths.fonts)
  ]])

/**
 * Cleanables
 *
 * @type {*[]}
 */
let cleanables = [
  path.join(paths.css, '*.map'),
  path.join(paths.js, '*.map'),
  path.join(paths.root, 'version.json')
]
  .map(fp => glob(fp))
  .reduce((acc, val) => acc.concat(val), [])
  .concat(copiables.map(x => x[1]))
  .filter((x, i, a) => a.indexOf(x) === i)
  .sort(function (a, b) { return a.localeCompare(b) })

/**
 * @type {{devtool: *, node: {fs: string}, resolve: {modules: string[]}, plugins: *[]}}
 */
const config = {
  devtool: process.env.NODE_ENV !== 'production' ? 'source-map' : false,
  resolve: {
    modules: moduleRoots
  },
  plugins: [
    new Clean(cleanables, { verbose: true }),
    new ExtraWatchWebpackPlugin({
      files: [
        'resources/modules/**/*.vue'
      ]
    }),
    new VersionFile({
      packageFile: path.join(__dirname, 'package.json'),
      template: path.join(_paths.source, 'version.ejs'),
      outputFile: path.join(paths.root, 'version.json')
    })
  ],
  node: {
    fs: 'empty'
  }
}

/*
 * Execution --------------------------------------------------------
 */
mix()
