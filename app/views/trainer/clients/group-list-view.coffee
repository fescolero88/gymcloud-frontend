Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

GroupModel = require 'models/trainer/group-model'

module.exports = class GroupItemView extends Marionette.ItemView

  template: require('templates/trainer/clients/group-item')

  tagName: 'li'

  className: 'row'

  modelEvents:
    sync: 'render'
    change: 'render'

  ui:
    deleteSingle: '.gc-clients-list-client-delete'

  events:
    'click @ui.deleteSingle': 'deleteSingle'

  deleteSingle: (ev) =>
    ev.preventDefault()
    App.request 'base:confirmationalModal',
      title: "Delete client"
      content: "Are you sure you want to delete #{@model.get('name')}?"
      confirmBtn: "Delete"
      confirmCallBack: =>
        @model.destroy()


module.exports = class GroupListView extends Marionette.CompositeView

  template: require('templates/trainer/clients/group-list')

  childView: GroupItemView

  childViewContainer: 'ul'

  initialize: =>
    @on 'rm-group', @rmGroup

  rmGroup: =>
    for check in @$el.find('input[type=checkbox]')
      if $(check).is(':checked')
        model = @collection.get $(check).data('id')
        model.destroy()
