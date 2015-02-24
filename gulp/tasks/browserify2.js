'use strict';

var config       = require('../config');
var gutil = require('gulp-util');
var _ = require('lodash');
var fs = require('fs');
var gulp = require('gulp');
var browserify = require('browserify');
var watchify     = require('watchify');
var source = require('vinyl-source-stream');
var mainBowerFiles = require('main-bower-files');
var nodeResolve = require('resolve');
var handleErrors = require('../util/handleErrors');
var browserSync  = require('browser-sync');

gulp.task('browserify2', ['build-vendor', 'build-app']);

gulp.task('build-vendor', function () {
  var b = browserify({
    debug: config.browserify.debug
  });

  config.bower.forEach(function (bowerPackage) {
    b.require(bowerPackage.require, {
      expose: bowerPackage.expose
    });
  });

  getNPMPackageIds().forEach(function (id) {
    b.require(nodeResolve.sync(id), { expose: id });
  });

  var stream = b.bundle().pipe(source('vendor.js'));
  stream.pipe(gulp.dest(config.scripts.dest))

  return stream;
});

gulp.task('build-app', function () {


  var b = watchify(browserify(_.extend(
        {
          entries: config.browserify.entries,
          extensions: config.browserify.extensions,
          paths: config.browserify.paths,
          debug: config.browserify.debug
        }, watchify.args)
  ));

  config.bower.forEach(function (bowerPackage) {
    b.external(bowerPackage.expose);
  });


  getNPMPackageIds().forEach(function (id) {
    b.external(id);
  });

  if ( !global.isProd ) {
    b.on('update', function() {
      rebundle();
    });
  }

  function rebundle() {
    var stream = b.bundle();

    gutil.log('Rebundle...');

    return stream.on('error', handleErrors)
      .pipe(source(config.browserify.bundleName))
      .pipe(gulp.dest(config.scripts.dest))
      .pipe(browserSync.reload({ stream: true, once: true }));
  }

  return rebundle();

});

/**
 * Helper function(s)
 */

function getBowerPackageIds() {
  // read bower.json and get dependencies' package ids
  var bowerManifest = {};
  try {
    bowerManifest = require('../../bower.json');
  } catch (e) {
    // does not have a bower.json manifest
  }
  return _.keys(bowerManifest.dependencies) || [];

}


function getNPMPackageIds() {
  // read package.json and get dependencies' package ids
  var packageManifest = {};
  try {
    packageManifest = require('../../package.json');
  } catch (e) {
    // does not have a package.json manifest
  }
  return _.keys(packageManifest.dependencies) || [];

}
