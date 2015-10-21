define [
  './item/view'
  './template'
], (
  GroupItemView
  template
) ->

  class AssignGroupsListView extends Marionette.CompositeView

    template: template

    className: 'gc-clients-list-wrapper gc-assign-list'

    childView: GroupItemView

    childViewContainer: 'ul.gc-clients-list'

    childViewOptions: (client, _index) ->
      entity: @entity
      entityType: @entityType

    viewComparator: (model) -> model.get('name')

    initialize: (options) ->
      @entity = options.entity
      @entityType = options.entityType