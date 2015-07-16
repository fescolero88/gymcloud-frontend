Backbone = require 'backbone'

module.exports = class SidebarChildItemsCollection extends Backbone.Collection

  modelId: (attrs) ->
    attrs.key
