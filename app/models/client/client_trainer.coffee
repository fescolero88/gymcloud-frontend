Backbone = require 'backbone'

module.exports = class ClientTrainerModel extends Backbone.Model

  urlRoot: '/api/mobile/clients'

  parse: (data) =>
    return data.trainer