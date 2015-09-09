module.exports = class AuthLayoutView extends Marionette.LayoutView

  template: require('templates/auth/auth-layout')

  regions:
    mainRegion: '#gc-auth-layout-region'
