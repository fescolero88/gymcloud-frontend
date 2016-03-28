define [
  './empty/view'
  './item/view'
  './template'
], (
  emptyView
  itemView
  collectionViewTpl
) ->

  class ClientEWPView extends Marionette.CompositeView

    template: collectionViewTpl
    className: 'gc-clientpage-exercises row'
    childView: itemView
    childViewContainer: 'ul'
    emptyView: emptyView

    collectionEvents:
      sync: 'render'

    childViewOptions: ->
      dataType: @dataType
      type: @type

    emptyViewOptions: ->
      dataType: @dataType
      type: @type

    initialize: (data) ->
      @dataType = data.dataType
      @type = data.type
      @collection.fetch()

    templateHelpers: ->
      dataType: @dataType
