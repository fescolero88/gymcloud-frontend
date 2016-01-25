module.exports = class ConfirmRegistrationView extends Marionette.ItemView

  template: require('templates/auth/confirm_registration')

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
    App.request 'accessToken:set', data.access_token
    @profileModel.fetch()

  profileRetrieved: ->
    accountType = @profileModel.get 'account_type'

    App.vent.trigger("module:main-#{accountType}:start")
    if accountType is 'trainer'
      window.location.replace '#/tr'
    else
      window.location.replace '#'
    App.vent.trigger 'profile:ready'
