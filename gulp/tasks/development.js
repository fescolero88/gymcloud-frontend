'use strict';

var gulp        = require('gulp');
var runSequence = require('run-sequence');

gulp.task('dev', ['clean'], function(cb) {

  cb = cb || function() {};

  runSequence(['styles', 'images', 'fonts'], 'templates', 'browserify2', 'watch', cb);

});
