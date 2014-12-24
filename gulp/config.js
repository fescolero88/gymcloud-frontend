'use strict';

var dest = "./static";
var src = './app';

module.exports = {

  serverport: 3000,
  server_root: 'static',

  styles: {
    src : [
        './bower_components/bootstrap/dist/css/bootstrap.min.css',
        './bower_components/fontawesome/css/font-awesome.min.css',
        src + '/styles/**/*.css'
    ],
    dest: dest + '/css'
  },

  scripts: {
    src : src + '/**/*.js',
    dest: dest + '/js'
  },

  images: {
    src : src + '/images/**/*',
    dest: dest + '/images'
  },

  fonts: {
    src : [
        './bower_components/fontawesome/fonts/fontawesome-webfont.*',
        './bower_components/bootstrap/fonts/*'
    ],
    dest: dest + '/fonts'
  },


  templates: {
    index: src + '/templates/index.html',
    watch: [
      src + '/templates/**/*.hbs'
    ],
    src: src + '/templates/**/*.hbs',
    dest: src + '/templates/'
  },

  dist: {
    root  : dest
  },

  browserify: {
    debug: true,
    extensions: ['.coffee'],
    entries   : [src + '/app.coffee'],
    bundleName: 'app.js'
  },

  test: {
    karma: 'test/karma.conf.js',
    protractor: 'test/protractor.conf.js'
  }

};
