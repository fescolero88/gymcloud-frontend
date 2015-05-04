Backbone = require 'backbone'

module.exports = class ConfirmRegistrationModel extends Backbone.Model

  url: '/api/users/confirmation'

  validation:
    confirmation_token:
      required: true
    email: 
      required: true
      pattern: 'email'

  confirm: (token, email) ->
    @set 'confirmation_token', token
    @set 'user[email]', email

    options = 
      url: @url
      type: 'POST'
      contentType: 'application/json'
      data: JSON.stringify @toJSON()

    (@sync || Backbone.sync).call(@, null, @, options)
      .then (response) =>
        console.log 'SUCCESS'
      
      .fail (xhr, textStatus, errorThrown) =>
        console.log 'FAIL'

