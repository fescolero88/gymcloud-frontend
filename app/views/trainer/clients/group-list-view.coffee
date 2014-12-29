Marionette = require 'backbone.marionette'

module.exports = class GroupItemView extends Marionette.ItemView
  template: Templates.trainer.clients.group_item
  tagName: 'li'
  className: 'row'

module.exports = class GroupListView extends Marionette.CompositeView
  template: Templates.trainer.clients.group_list
  childView: GroupItemView
  childViewContainer: 'ul'

  initialize: =>
    @on 'rm-group', @rm_group

  rm_group: =>
    for check in @$el.find('input[type=checkbox]')
      if $(check).is(':checked')
        model = @collection.get $(check).data('id')
        model.destroy()
