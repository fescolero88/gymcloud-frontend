'use strict';

var config     = require('../config');
var changed    = require('gulp-changed');
var gulp       = require('gulp');
var concat     = require('gulp-concat');
var stylus     = require('gulp-stylus');

gulp.task('styles', function() {

  var dest = config.styles.dest;
  var src = [ config.stylus.src ];
  src = src.concat(config.styles.src);

  return gulp.src(src)
    .pipe(stylus({
      'include css': true
    }))
    .pipe(concat('app.css'))
    .pipe(gulp.dest(dest))

});
