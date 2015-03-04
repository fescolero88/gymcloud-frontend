Backbone = require 'backbone'

module.exports = class MembersCollection extends Backbone.Collection

  urlRoot: '/api/mobile/client_groups'
