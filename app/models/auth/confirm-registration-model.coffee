define ->

  class ConfirmRegistrationModel extends Backbone.Model

    url: '/users/confirmation/confirm.json'

    validation:

      confirmation_token:
        required: true

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
