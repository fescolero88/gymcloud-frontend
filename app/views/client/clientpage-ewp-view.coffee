define [
  'backbone.marionette'
  'templates/client/assigments-empty'
  'templates/client/ewp_item'
  'templates/client/ewp_list'
], (
  Marionette
  emptyViewTpl
  itemViewTpl
  collectionViewTpl
) ->

  class EmptyView extends Marionette.ItemView

    template: emptyViewTpl

    initialize: (data) =>
      @dataType = data.dataType

    templateHelpers: =>
      dataType: @dataType

  class ClientEWPItemView extends Marionette.ItemView

    template: itemViewTpl

    tagName: 'li'
    className: 'row'

    initialize: (options) =>
      @dataType = options.dataType

    templateHelpers: =>
      dataType: @dataType
      isExercises: (type, options) ->
        if type == 'exercises'
          options.fn(this)
        else
          options.inverse(this)

  class ClientEWPView extends Marionette.CompositeView

    template: collectionViewTpl

    childView: ClientEWPItemView
    childViewContainer: 'ul'
    emptyView: EmptyView

    collectionEvents:
      sync: 'render'

    childViewOptions: ->
      dataType: @dataType

    emptyViewOptions: ->
      dataType: @dataType

    initialize: (data) ->
      @dataType = data.dataType
      @collection.fetch()

    templateHelpers: ->
      dataType: @dataType