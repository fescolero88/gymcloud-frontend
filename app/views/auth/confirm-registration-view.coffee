Marionette = require 'backbone.Marionette'

module.exports = class ConfirmRegistrationView extends Marionette.ItemView

  template: Templates.auth.confirm_registration

  initialize: (options) ->
    @token = options.token
    @profileModel = options.profileModel

    @listenTo @model, 'model:auth_confirm:fail', @confirmFailed
    @listenTo @model, 'model:auth_confirm:success', @confirmSuccess
    @listenTo @profileModel, 'change', @profileRetrieved

  onDestroy: =>


  onRender: ->
    setTimeout =>
      @model.confirm @token
    , 2000

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
