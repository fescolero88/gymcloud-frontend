Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

module.exports = class ClientItemView extends Marionette.ItemView
  template: Templates.trainer.clients.client_item
  tagName: 'li'
  className: 'row'

  modelEvents:
    "sync": "render"
    "change": "render"


module.exports = class ClientListView extends Marionette.CompositeView
  template: Templates.trainer.clients.client_list
  childView: ClientItemView
  childViewContainer: 'ul'

  ui:
    checkedCheckboxes: 'input[type=checkbox]:checked'

  initialize: =>
    @on 'rm-client', @rmClient

  rmClient: =>
    for check in @$el.find('input[type=checkbox]')
      if $(check).is(':checked')
        model = @collection.get $(check).data('id')
        model.destroy()
