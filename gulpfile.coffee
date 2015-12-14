gulp = require('gulp')
gutil = require('gulp-util')
clean = require('gulp-clean')
plumber = require('gulp-plumber')
coffeelint = require('gulp-coffeelint')
stylish = require('coffeelint-stylish')
lazypipe = require('lazypipe')
webpack = require('webpack')
gulpWebpack = require('gulp-webpack')
WebpackDevServer = require('webpack-dev-server')
webpackConfig = require('./webpack.config.js')
settings = require('./settings')

# The development server (the recommended option for development)
gulp.task 'default', ['webpack-dev-server']

# Build and watch cycle (another option for development)
# Advantage: No server required, can run app from filesystem
# Disadvantage: Requests are not blocked until bundle is available,
#               can serve an old app on refresh
gulp.task 'build-dev', ['webpack:build-dev'], ->
  gulp
    .watch ['app/**/*'], ['webpack:build-dev']
  return

# Production build
gulp.task 'build', ['build:clean', 'webpack:build']
gulp.task 'webpack:build', (callback) ->

  # modify some webpack config options
  myConfig = Object.create(webpackConfig)
  myConfig.bail = true
  myConfig.plugins = myConfig.plugins.concat(
    new webpack.DefinePlugin(
      'process.env':
        NODE_ENV: JSON.stringify('production')
    ),
    new webpack.optimize.DedupePlugin(),
    new webpack.optimize.UglifyJsPlugin()
  )

  # run webpack
  gulp
    .src([
      './app/app'
    ])
    .pipe(
      plumber(
        errorHandler: (err) ->
          gutil.log '[error]', err.toString(colors: true)
          process.exit(1)
      )
    )
    .pipe(gulpWebpack(myConfig))
    .pipe(gulp.dest('build/'))

# modify some webpack config options
myDevConfig = Object.create(webpackConfig)
myDevConfig.devtool = 'sourcemap'
myDevConfig.debug = true

# create a single instance of the compiler to allow caching
devCompiler = webpack(myDevConfig)
gulp.task 'webpack:build-dev', (callback) ->

  # run webpack
  devCompiler.run (err, stats) ->
    throw new gutil.PluginError('webpack:build-dev', err)  if err
    gutil.log '[webpack:build-dev]', stats.toString(colors: true)
    callback()
    return

  return

gulp.task 'webpack-dev-server', (callback) ->

  # modify some webpack config options
  myConfig = Object.create(webpackConfig)
  myConfig.devtool = 'eval'
  myConfig.debug = true
  devServerConfig =
    publicPath: '/' + myConfig.output.publicPath
    stats:
      colors: true

  # Start a webpack-dev-server
  new WebpackDevServer(webpack(myConfig), devServerConfig)
    .listen 8080, 'localhost', (err) ->
      throw new gutil.PluginError('webpack-dev-server', err)  if err
      gutil.log '[webpack-dev-server]',
        'http://localhost:8080/webpack-dev-server/index.html'
      return

  return

gulp.task 'lint', [
  'lint:coffee'
]

gulp.task 'lint:coffee', ->
  gulp
    .src('./app/**/*.coffee')
    .pipe(coffeelint('./coffeelint.json'))
    .pipe(coffeelint.reporter(stylish))
    .pipe(coffeelint.reporter('failOnWarning'))

gulp.task 'build:clean', ->
  gulp
    .src('build', read: false)
    .pipe(clean())

gulp.task 'dist:clean', ->
  gulp
    .src([
      'dist/'
    ])
    .pipe(clean())

gulp.task 'dist:prepare', ['dist:clean'], ->
  gulp
    .src([
      'build/**'
      'index.html'
      'favicon.ico'
    ], base: '.')
    .pipe(gulp.dest('dist/'))
