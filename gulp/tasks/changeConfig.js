'use strict';

var config      = require('../config');
var gulp        = require('gulp');
var replace     = require('gulp-replace');

gulp.task('changeConfig', function() {
  return gulp.src(config.configFile)
    .pipe(replace('production = false', 'production = true'))
    .pipe(gulp.dest(config.configFileDest));
});
