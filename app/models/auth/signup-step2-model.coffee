Backbone = require 'backbone'

module.exports = class SignUpStep2Model extends Backbone.Model
  urlRoot: '/api/mobile/clients'

  validation:
    first_name:
      required: true

    last_name:
      required: true

    address:
      required: true

    city:
      required: true

    state:
      required: true

    zip:
      required: true
      pattern: 'digits'

    birth:
      required: true


