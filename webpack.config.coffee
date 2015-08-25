path = require('path')
webpack = require('webpack')

require('dotenv').load()

module.exports =

  cache: true
  debug: true
  # devtool: 'source-map'

  context: path.resolve('app')

  entry:
    main: 'app'

  output:
    path: path.resolve('build')
    publicPath: 'build/'
    filename: 'app-[name].js'
    chunkFilename: '[chunkhash].js'

  resolve:

    root: [
      path.resolve('app')
      path.resolve('.')
      path.resolve('bower_components')
    ]

    alias:
      'config': path.join(__dirname, 'config', process.env.NODE_ENV || 'test')
      'selectize': 'bower_components/selectize/dist/js/selectize'
      'spinner': 'bower_components/spin.js/spin.js'
      'jquery-sortable': 'bower_components/jquery-sortable/source/js/jquery-sortable.js'
      'datetimepicker': 'bower_components/eonasdan-bootstrap-datetimepicker/src/js/bootstrap-datetimepicker'
      'nanoscroller': 'bower_components/nanoscroller/bin/javascripts/jquery.nanoscroller.js'
      'messenger': 'bower_components/messenger/build/js/messenger.js'

    extensions: [
      ''
      '.webpack.js'
      '.web.js'
      '.js'
      '.json'
      '.coffee'
      '.jade'
      '.hbs'
      '.scss'
      '.styl'
      '.css'
    ]

  module:

    noParse: /\.min\.js/

    loaders: [
      {
        test: /\.coffee$/
        loader: 'coffee'
      }
      {
        test: /\.hbs$/
        loader: 'handlebars'
        query:
          runtime: 'handlebars/runtime'
          #inlineRequires: 'app/images/'
          helperDirs: [
            __dirname + '/app/handlers/handlebars'
          ]
      }
      {
        test: /\.jade/
        loader: 'jade'
      }
      {
        test: /\.css$/
        loader: 'style!css'
      }
      {
        test: /\.styl$/
        loader: 'style!css!stylus'
      }
      {
        test: /\.scss$/
        loader: 'style!css!sass?outputStyle=expanded&' + \
          # 'includePaths[]=' + (path.resolve('bower_components')) + '&' + \
          'includePaths[]=' + (path.resolve('node_modules'))
      }
      {
        test: /\.otf/
        loader: 'file?prefix=font/&mimetype=application/x-font-opentype'
      }
      {
        test: /\.eot/
        loader: 'file?prefix=font/&mimetype=application/vnd.ms-fontobject'
      }
      {
        test: /\.ttf/
        loader: 'file?prefix=font/&mimetype=application/x-font-truetype'
      }
      {
        test: /\.svg/
        loader: 'file?prefix=font/&mimetype=image/svg+xml'
      }
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/
        loader: 'file?prefix=font/&mimetype=application/font-woff'
      }
      {
        test: /\.png$/
        loader: 'file?prefix=img/&mimetype=image/png'
      }
      {
        test: /\.jpg$/
        loader: 'file?prefix=img/&mimetype=image/jpg'
      }
      {
        test: /\.gif$/
        loader: 'file?prefix=img/&mimetype=image/gif'
      }
    ]

  externals: {}

  plugins: [
      new webpack.ProvidePlugin(
        jQuery: 'jquery'
        $: 'jquery'
        'window.jQuery': 'jquery'
        _: 'lodash'
        Backbone: 'backbone'
      )
    ,
      new webpack.ResolverPlugin(
        new webpack.ResolverPlugin.DirectoryDescriptionFilePlugin('bower.json', ['main'])
      )
  ]

  node:
    fs: 'empty'
