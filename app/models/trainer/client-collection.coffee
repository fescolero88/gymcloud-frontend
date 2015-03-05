Backbone = require 'backbone'

module.exports = class ClientCollection extends Backbone.Collection

  url: '/api/mobile/clients'
