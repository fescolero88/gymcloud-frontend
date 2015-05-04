Marionette = require 'backbone.Marionette'

module.exports = class ConfirmRegistrationView extends Marionette.ItemView

  template: Templates.auth.confirm_registration

  initialize: (options) ->
    @token = options.token
    console.log 'the token', @token

  onRender: ->
    alert 'rendered'
    console.log 'the model', @model
    setTimeout =>
      @model.confirm(@token, 'gerard.arguelles@live.com')
    , 5000
