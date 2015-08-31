define [
  'backbone.marionette'
  'templates/trainer/properties/properties_empty'
  'templates/trainer/properties/properties_item'
  'templates/trainer/properties/property-list'
], (
  Marionette
  emptyViewTpl
  itemViewTpl
  listViewTpl
) ->
  class EmptyView extends Marionette.ItemView

    template: emptyViewTpl

  class PropertiesItemView extends Marionette.ItemView

    template: itemViewTpl

    tagName: 'li'

    className: 'row'

    events:
      'change .switch input': 'switchProperty'

    switchProperty: (ev) ->
      state = ev.currentTarget.checked
      @model.save(is_visible: state)

  class PropertyListView extends Marionette.CompositeView

    template: listViewTpl

    childView: PropertiesItemView

    childViewOptions: (model, index) ->
      attributes:
        'data-id': model.id

    childViewContainer: 'ul'

    emptyView: EmptyView

    templateHelpers: =>
      collection: @collection

    isEmpty: (collection) ->
      return !collection.length

    onShow: ->
      @$el.find('.gc-properties-list').sortable
        handle: '.draggable-handle'
        placeholder: '<li class="placeholder sortable-placeholder"/>'
        onDrop: ($item) =>
          $item.removeClass('dragged').removeAttr('style')
          $('body').removeClass('dragging')
          @$(@childViewContainer).children().each (index, item) =>
            id = $(item).data('id')
            model = @collection.get(id)
            model.set(position: index)
            model.save() unless _.isEmpty(model.changed)