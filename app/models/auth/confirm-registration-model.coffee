Backbone = require 'backbone'

module.exports = class ConfirmRegistrationModel extends Backbone.Model

  url: '/api/mobile/users/confirmation/confirm.json'

  validation:
    confirmation_token:
      required: true
    email: 
      required: true
      pattern: 'email'

  confirm: (token) ->
    @set 'confirmation_token', token

    options = 
      url: @url
      type: 'POST'
      contentType: 'application/json'
      data: JSON.stringify @toJSON()

    (@sync || Backbone.sync).call(@, null, @, options)
      .then (response) =>
        @trigger 'model:auth_confirm:success', response
      .fail (xhr, textStatus, errorThrown) =>
        @trigger 'model:auth_confirm:fail'
