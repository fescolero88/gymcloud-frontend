'use strict';

var gulp        = require('gulp');
var runSequence = require('run-sequence');

gulp.task('stage', ['clean'], function(cb) {

  cb = cb || function() {};

  global.isProd = true;

  runSequence('styles', 'images', 'fonts', 'templates', 'browserify2', cb);

});
