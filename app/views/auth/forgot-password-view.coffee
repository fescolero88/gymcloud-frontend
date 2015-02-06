config = require 'config'
Marionette = require 'backbone.marionette'

module.exports = class ForgotPasswordView extends Marionette.ItemView
  template: Templates.auth.forgot_password
