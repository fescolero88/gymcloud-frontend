'use strict';

var config      = require('../config');
var gulp        = require('gulp');
var replace     = require('gulp-replace');

gulp.task('changeConfig', function() {
  gulp.src(config.src + '/config.cofee')
    .pipe(replace('production = false', 'production = true'))
});
