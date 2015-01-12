Backbone = require 'backbone'

module.exports = class GroupCollection extends Backbone.Collection
  url: '/api/mobile/client_groups'
