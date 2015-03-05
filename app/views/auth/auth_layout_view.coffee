Marionette = require 'backbone.marionette'

module.exports = class AuthLayoutView extends Marionette.LayoutView

  template: Templates.auth.auth_layout

  regions:
    mainRegion: '#gc-auth-layout-region'
