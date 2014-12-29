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
        var count = 0;
        var new_path = filePath.replace('app/templates/', '').replace(/\-/g,
            function(match) {
              count++;
              if(count==1) {
                return match;
              }
              else {
                return '_';
              }
            });
        return declare.processNameByPath(new_path);
      }
    }))
    .pipe(concat('templates_build.js'))
    .pipe(wrap('var Handlebars = require("handlebars");\n <%= contents %>'))
    .pipe(gulp.dest(config.templates.dest));

});
