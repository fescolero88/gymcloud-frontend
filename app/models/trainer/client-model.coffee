Backbone = require 'backbone'

module.exports = class ClientModel extends Backbone.Model
  urlRoot: '/api/mobile/clients'

  validation:
    first_name:
      required: true

    last_name:
      required: true

    email:
      required: true
      pattern: 'email'

    weight:
      required: false
      isFloat: true

    height:
      required: false
      isFloat: true

    bodyfat:
      required: false
      isFloat: true

    address:
      required: false

    zip:
      required: false
      pattern: 'digits'

    works_at:
      required: false
