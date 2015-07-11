Backbone = require 'backbone'

module.exports = class SidebarItemsCollection extends Backbone.Collection
  comparator: (model) ->
    [-model.get('isFolder'), model.get('title')]
