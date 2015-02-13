Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

module.exports = class ClientItemView extends Marionette.ItemView
  template: Templates.trainer.clients.client_item
  tagName: 'li'
  className: 'row'

  modelEvents:
    "sync": "render"
    "change": "render"

  ui:
    deleteSingle: '.gc-clients-list-client-delete'
    moveSingle: '.gc-clients-list-client-move'

  events:
    'click @ui.deleteSingle': 'deleteSingle'
    'click @ui.moveSingle': 'moveSingle'

  deleteSingle: (ev) =>
    ev.preventDefault()
    model = @_parent.collection.get $(ev.currentTarget).data('id')
    model.destroy()

  moveSingle: (ev) =>
    ev.preventDefault()
    $(ev.currentTarget).closest('.row').find(':checkbox').prop('checked', true)
    App.vent.trigger 'individual:move', ev


module.exports = class ClientListView extends Marionette.CompositeView
  template: Templates.trainer.clients.client_list
  childView: ClientItemView
  childViewContainer: 'ul'

  initialize: =>
    @on 'rm-client', @rmClient

  rmClient: =>
    for check in @$el.find('input[type=checkbox]')
      if $(check).is(':checked')
        model = @collection.get $(check).data('id')
        model.destroy()
