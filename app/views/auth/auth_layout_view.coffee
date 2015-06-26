Marionette = require 'backbone.marionette'

module.exports = class AuthLayoutView extends Marionette.LayoutView

  template: require('templates/auth/auth_layout')

  regions:
    mainRegion: '#gc-auth-layout-region'
