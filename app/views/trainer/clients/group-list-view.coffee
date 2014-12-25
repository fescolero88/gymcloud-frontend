Marionette = require 'backbone.marionette'
groupItemTemplate = require '../../../templates/trainer/clients/group-item'
groupListTemplate = require '../../../templates/trainer/clients/group-list'

module.exports = class GroupItemView extends Marionette.ItemView
  template: groupItemTemplate
  tagName: 'li'
  className: 'row'

module.exports = class GroupListView extends Marionette.CompositeView
  template: groupListTemplate
  childView: GroupItemView
  childViewContainer: 'ul'

  initialize: =>
    @on 'rm-group', @rm_group

  rm_group: =>
    for check in @$el.find('input[type=checkbox]')
      if $(check).is(':checked')
        model = @collection.get $(check).data('id')
        model.destroy()
