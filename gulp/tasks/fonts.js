'use strict';

var config     = require('../config');
var changed    = require('gulp-changed');
var gulp       = require('gulp');

gulp.task('fonts', function() {
  var dest = config.fonts.dest;
  var src = config.fonts.src;

  return gulp.src(src)
    .pipe(changed(dest))
    .pipe(gulp.dest(dest));
});
