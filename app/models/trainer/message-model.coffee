Backbone = require 'backbone'

module.exports = class MessageModel extends Backbone.Model

  validation:

    body:
      required: true
      msg: 'Type message'

    clients:
      required: true
      msg: 'Choose client'
