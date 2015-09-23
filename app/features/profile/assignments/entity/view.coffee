define [
  './item/view'
  './empty/view'
  './template'
], (
  ItemView
  EmptyView
  template
) ->

  class AssignmentsListView extends Marionette.CompositeView

    className: 'gc-exercises-assign'

    template: template

    behaviors: ->
      auto_complete:
        onItemAdd: (id) =>
          Backbone.history.navigate("#{@viewType}/#{id}", trigger: true)
        collection: =>
          @collection.map (item) =>
            folder: name: _.humanize(@viewType)
            id: item.get('id')
            name: item.get('name')
            label: item.get('name')

    emptyView: EmptyView

    childView: ItemView

    childViewContainer: 'ul'

    childViewOptions: ->
      viewType: @viewType

    templateHelpers: =>
      viewType: _.humanize(@viewType)

    initialize: (data) ->
      @viewType = data.viewType