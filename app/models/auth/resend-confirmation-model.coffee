Backbone = require 'backbone'

module.exports = class ResendConfirmationModel extends Backbone.Model

  url: '/api/mobile/users/confirmation/send_instructions.json'

  validation:
    email:
      required: true
      pattern: 'email'
      msg: 'Please enter a valid email'

  resendConfirmation: ->
    if @isValid 'email'
      options =
        url: @url
        type: 'POST'
        contentType: 'application/json'
        data: JSON.stringify @toJSON()

      (@sync || Backbone.sync).call(@, null, @, options)
        .then (response) =>
          @trigger 'model:auth_resend:success', response
        .fail (xhr, textStatus, errorThrown) =>
          @trigger 'model:auth_resend:fail', 'Something went wrong'
