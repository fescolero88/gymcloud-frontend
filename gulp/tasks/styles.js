'use strict';

var config     = require('../config');
var changed    = require('gulp-changed');
var gulp       = require('gulp');
var concat     = require('gulp-concat');

gulp.task('styles', function() {

  var dest = config.styles.dest;

  return gulp.src(config.styles.src)
    .pipe(concat('app.css'))
    .pipe(gulp.dest(dest))

});
