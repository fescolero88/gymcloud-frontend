Marionette = require 'backbone.marionette'

module.exports = class ConfirmRegistrationView extends Marionette.ItemView

  template: Templates.auth.confirm_registration

  initialize: (options) ->
    @token = options.token
    @profileModel = options.profileModel
    @listenTo @profileModel, 'change', @profileRetrieved

  modelEvents:
    'model:auth_confirm:fail': 'confirmFailed'
    'model:auth_confirm:success': 'confirmSuccess'

  onRender: ->
    @model.confirm @token

  confirmFailed: ->
    # todo: implement resending of confirmation email

  confirmSuccess: (data) ->
    window.localStorage.setItem 'accessToken', data.access_token
    @profileModel.fetch()

  profileRetrieved: ->
    accountType = @profileModel.get 'account_type'

    App.vent.trigger("module:main-#{accountType}:start")
    if accountType is 'trainer'
      window.location.replace '#/tr'
    else
      window.location.replace '#'
    App.vent.trigger 'profile:ready'
