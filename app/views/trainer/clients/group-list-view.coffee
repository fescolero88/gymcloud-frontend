Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

module.exports = class GroupItemView extends Marionette.ItemView
  template: Templates.trainer.clients.group_item
  tagName: 'li'
  className: 'row'

module.exports = class GroupListView extends Marionette.CompositeView
  template: Templates.trainer.clients.group_list
  childView: GroupItemView
  childViewContainer: 'ul'

  initialize: =>
    @on 'rm-group', @rmGroup
    @on 'submit-group-form', @submitGroupForm

  rmGroup: =>
    for check in @$el.find('input[type=checkbox]')
      if $(check).is(':checked')
        model = @collection.get $(check).data('id')
        model.destroy()

  submitGroupForm: (name)->
    new_group = new Backbone.Model()
    new_group.set 'name', name
    new_group.url = '/api/mobile/client_groups'
    new_group.save()
    @collection.add new_group
