Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

class ClientItemView extends Marionette.ItemView

  template: require('templates/trainer/clients/client-item')

  tagName: 'li'

  className: 'row'

  modelEvents:
    sync: 'render'
    change: 'render'

  ui:
    deleteSingle: '.gc-clients-list-client-delete'
    moveSingle: '.gc-clients-list-client-move'

  events:
    'click @ui.deleteSingle': 'deleteSingle'
    'click @ui.moveSingle': 'moveSingle'

  deleteSingle: (ev) =>
    ev.preventDefault()
    App.request 'base:confirmationalModal',
      title: "Delete client"
      content: "Are you sure you want to delete #{@model.get('first_name')} #{@model.get('last_name')}?"
      confirmBtn: "Delete"
      confirmCallBack: =>
        @model.destroy()

  moveSingle: (ev) =>
    ev.preventDefault()
    $(ev.currentTarget).closest('.row').find(':checkbox').prop('checked', true)
    @trigger 'individual:move'


module.exports = class ClientListView extends Marionette.CompositeView

  template: require('templates/trainer/clients/client-list')

  childView: ClientItemView

  childViewContainer: 'ul'

  initialize: =>
    @on 'rm-client', @removeClient

  childEvents:
    'individual:move': 'moveClient'

  removeClient: =>
    for check in @$el.find('input[type=checkbox]')
      if $(check).is(':checked')
        model = @collection.get $(check).data('id')
        model.destroy()

  moveClient: =>
    @trigger 'individual:move'
