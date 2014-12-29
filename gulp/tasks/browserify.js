'use strict';

var config       = require('../config');
var gulp         = require('gulp');
var gulpif       = require('gulp-if');
var gutil        = require('gulp-util');
var source       = require('vinyl-source-stream');
var streamify    = require('gulp-streamify');
var watchify     = require('watchify');
var browserify   = require('browserify');
var handleErrors = require('../util/handleErrors');
var browserSync  = require('browser-sync');

function buildScript(file) {

  var bundler = browserify({
    entries: config.browserify.entries,
    extensions: config.browserify.extensions,
    insertGlobals: true,
    paths: config.browserify.paths,
    debug: config.browserify.debug
  });

  if ( !global.isProd ) {
    bundler = watchify(bundler);
    bundler.on('update', function() {
      rebundle();
    });
  }

  function rebundle() {
    var stream = bundler.bundle();

    gutil.log('Rebundle...');

    return stream.on('error', handleErrors)
      .pipe(source(file))
      .pipe(gulp.dest(config.scripts.dest))
      .pipe(browserSync.reload({ stream: true, once: true }));
  }

  return rebundle();

}

gulp.task('browserify', function() {

  return buildScript(config.browserify.bundleName);

});
