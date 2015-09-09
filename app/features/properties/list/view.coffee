define [
  './empty/view'
  './item/view'
  './template'
], (
  EmptyView
  ItemView
  template
) ->

  class PropertyListView extends Marionette.CompositeView

    className: 'gc-properties-list-wrapper row'

    template: template

    emptyView: EmptyView

    childView: ItemView

    childViewContainer: 'ul'

    childViewOptions: (model, index) ->
      attributes:
        'data-id': model.id

    templateHelpers: =>
      collection: @collection

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
