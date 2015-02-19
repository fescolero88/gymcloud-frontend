Backbone = require 'backbone'

module.exports = class SignUpStep1Model extends Backbone.Model
  urlRoot: '/api/mobile/clients'

  validation:
    account_type:
      required: false
      pattern: 'digits'

    email:
      required: true
      pattern: 'email'

    password:
      required: true

    password_confirmation:
      required: true


