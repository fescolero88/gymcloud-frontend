Backbone = require 'backbone'

module.exports = class ClientProgramsCollection extends Backbone.Collection

  url: '/api/mobile/me/programs'