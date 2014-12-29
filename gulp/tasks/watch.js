'use strict';

var config        = require('../config');
var gulp          = require('gulp');

gulp.task('watch', ['browserSync', 'server'], function() {

  gulp.watch(config.scripts.src, ['browserify']);
  gulp.watch(config.styles.src,  ['styles', 'reload']);
  gulp.watch(config.images.src,  ['images', 'reload']);
  gulp.watch(config.fonts.src,  ['fonts', 'reload']);
  gulp.watch(config.templates.watch, ['templates']);

});
