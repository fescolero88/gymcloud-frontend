Backbone = require 'backbone'

module.exports = class ResetPasswordModel extends Backbone.Model

  urlRoot: '/users/password'

  validation:

    password:
      required: true
      minLength: 6
      msg: 'Password must be 6 characters'

    password_confirmation: [
      equalTo: 'password'
      msg: 'The passwords do not match'
    ,
      required: true
      minLength: 6
      msg: 'Password must be 6 characters'
    ]
