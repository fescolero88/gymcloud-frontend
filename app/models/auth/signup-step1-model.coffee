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
      minLength: 6
      msg: 'Password must be 6 characters'

    password_confirmation: [
      equalTo: 'password'
      msg: 'The passwords does not match'
    ,
      required: true
      minLength: 6
      msg: 'Password must be 6 characters'
    ]
