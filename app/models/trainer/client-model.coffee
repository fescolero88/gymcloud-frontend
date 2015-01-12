Backbone = require 'backbone'

module.exports = class ClientModel extends Backbone.Model
  urlRoot: '/api/mobile/clients'
