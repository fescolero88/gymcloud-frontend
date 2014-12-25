'use strict';

var config         = require('../config');
var gulp           = require('gulp');
var declare        = require('gulp-declare');
var wrap           = require('gulp-wrap');
var replace        = require('gulp-replace');
var defineModule   = require('gulp-define-module');
var handlebars     = require('gulp-handlebars');

gulp.task('templates', function() {

  // Put our index.html in the dist folder
  gulp.src(config.templates.index)
    .pipe(gulp.dest(config.dist.root));

  return gulp.src(config.templates.src)
    .pipe(handlebars())
    .pipe(defineModule('commonjs'))
    .pipe(replace(/require\(["']handlebars["']\)/, 'require("handlebars")["default"]'))
    .pipe(gulp.dest(config.templates.dest));

});
