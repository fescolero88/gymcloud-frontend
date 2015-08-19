Backbone = require 'backbone'

module.exports = class ForgotPasswordModel extends Backbone.Model

  url: '/users/password.json'

  toJSON: ->
    user: _.clone(this.attributes)

  validation:

    email:
      required: true
      pattern: 'email'
