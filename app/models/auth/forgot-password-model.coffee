Backbone = require 'backbone'

module.exports = class ForgotPasswordModel extends Backbone.Model

  url: '/api/mobile/users/forgot_password'

  validation:
    email:
      required: true
      pattern: 'email'
