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

    initialize: ->
      App.vent.on 'properties:addModel', @addProperty

    isEmpty: (collection) ->
      return !collection.length

    addProperty: (model) =>
      @collection.unshift model

    rmProperty: (ev) ->
      ev.preventDefault()
      model_id = $(ev.currentTarget).data('id')
      model = @collection.get model_id
      model.destroy()

    onShow: ->
      @$el.find('.gc-properties-list').sortable
        handle: '.draggable-handle'
        placeholder: '<li class="placeholder sortable-placeholder"/>'
        onDrop: ($item) =>
          model_id = $item.data('id')
          model = @collection.get model_id
          $item.removeClass('dragged').removeAttr('style')
          $('body').removeClass('dragging')
          new_position = $('.gc-properties-list li').index($item)+1
          model.set 'position', new_position
          model.save()
