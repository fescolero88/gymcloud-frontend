Backbone = require 'backbone'

module.exports = class SidebarItemsCollection extends Backbone.Collection

  modelId: (attrs) ->
    attrs.key

  comparator: (model) ->
    [-model.get('isFolder'), model.get('title')]
