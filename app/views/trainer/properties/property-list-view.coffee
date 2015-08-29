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

    modelEvents:
      sync: 'render'

  class PropertyListView extends Marionette.CompositeView

    template: listViewTpl

    childView: PropertiesItemView

    childViewOptions: (model, index) ->
      attributes:
        'data-id': model.id

    childViewContainer: 'ul'

    emptyView: EmptyView

    events:
      'click @ui.rmProperty': 'rmProperty'

    ui:
      rmProperty: '.gc-properties-property-delete'

    templateHelpers: =>
      collection: @collection

    isEmpty: (collection) ->
      return !collection.length

    # TODO: rename to switcher
    rmProperty: (ev) ->
      ev.preventDefault()
      model_id = $(ev.currentTarget).data('id')
      model = @collection.get model_id
      model.save(is_visible: !model.get('is_visible'))

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