"use strict";

const Mix = require('webpack-mix');
const Clean = require('clean-webpack-plugin');
const VersionFile = require('webpack-version-file-plugin');

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
    let mix = Mix.webpackConfig(config);

    mix.js(path.join(sourcePath, 'js/app.js'), paths.js);
    mix.sass(path.join(sourcePath, 'sass/app.scss'), paths.css, {
        sourceComments: !mix.config.production,
    });

    copiables.forEach(function (i) {
        mix.copy(i[0], i[1], false);
    });

    mix.sourceMaps();
};

const sourcePath = path.join(__dirname, 'assets');

const publicPath = path.join(__dirname, 'public');

const paths = {
    js: path.join(publicPath, 'js'),
    css: path.join(publicPath, 'css'),
    fonts: path.join(publicPath, 'fonts'),
    images: path.join(publicPath, 'images'),
};

const copiables = [
    [path.join(sourcePath, 'images/favicon.png'), path.join(publicPath, 'favicon.ico')],
    [path.join(sourcePath, 'images'), paths.images],
    ['node_modules/font-awesome/fonts/', paths.fonts],
];

const config = {
    devtool: 'source-map',
    plugins: [
        new Clean(copiables.map(x => x[1]), {verbose: true}),
        new VersionFile({
            packageFile: path.join(__dirname, 'package.json'),
            template: path.join(sourcePath, 'version.ejs'),
            outputFile: path.join(publicPath, 'version.json')
        })
    ],
    node: {
        fs: 'empty'
    }
};

mix();
