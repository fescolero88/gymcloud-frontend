Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

GroupModel = require 'models/trainer/group-model'

module.exports = class GroupItemView extends Marionette.ItemView

  template: Templates.trainer.clients.group_item

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
    @model.destroy()

module.exports = class GroupListView extends Marionette.CompositeView

  template: Templates.trainer.clients.group_list

  childView: GroupItemView

  childViewContainer: 'ul'

  initialize: =>
    @on 'rm-group', @rmGroup

  rmGroup: =>
    for check in @$el.find('input[type=checkbox]')
      if $(check).is(':checked')
        model = @collection.get $(check).data('id')
        model.destroy()
