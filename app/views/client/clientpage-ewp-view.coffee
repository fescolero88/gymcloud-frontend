define [
  'templates/client/assigments-empty'
  'templates/client/ewp_item'
  'templates/client/ewp_list'
], (
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
      @type = options.type

    templateHelpers: =>
      dataType: @dataType
      type: @type
      isExercises: (type, options) ->
        if type == 'exercises'
          options.fn(@)
        else
          options.inverse(@)

  class ClientEWPView extends Marionette.CompositeView

    template: collectionViewTpl

    childView: ClientEWPItemView
    childViewContainer: 'ul'
    emptyView: EmptyView

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
