'use strict';

var config         = require('../config');
var gulp           = require('gulp');
var declare        = require('gulp-declare');
var wrap           = require('gulp-wrap');
var replace        = require('gulp-replace');
var defineModule   = require('gulp-define-module');
var concat        = require('gulp-concat');
var handlebars     = require('gulp-handlebars');

gulp.task('templates', function() {

  // Put our index.html in the dist folder
  gulp.src(config.templates.index)
    .pipe(gulp.dest(config.dist.root));

  return gulp.src(config.templates.src)
    .pipe(handlebars())
    .pipe(wrap('Handlebars.template(<%= contents %>)'))
    .pipe(declare({
      root: 'module.exports',
      noRedeclare: true,
      processName: function(filePath) {
        var newPath = filePath.replace(/app\/templates\/(.*)/, function(match) {

          return match.replace('app/templates/', '').replace(/-/g, '_');
        });
        return declare.processNameByPath(newPath);
      }
    }))
    .pipe(concat('templates_build.js'))
    .pipe(wrap('var Handlebars = require("handlebars");\n <%= contents %>'))
    .pipe(gulp.dest(config.templates.dest));

});
