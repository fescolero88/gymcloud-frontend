Marionette = require 'backbone.marionette'

module.exports = class ResendConfirmationView extends Marionette.ItemView

  template: Templates.auth.resend_confirmation

  initialize: (options) ->


