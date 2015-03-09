Backbone = require 'backbone'

module.exports = class LoginModel extends Backbone.Model

  validation:

    email:
      required: true
      pattern: 'email'
      msg: 'Value should be valid email address'

    password:
      required: true
