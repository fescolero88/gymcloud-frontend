define [
  './template'
], (
  itemViewTpl
) ->

  class ClientEWPItemView extends Marionette.ItemView

    template: itemViewTpl

    tagName: 'li'
    className: 'row gc-folder'

    initialize: (options) =>
      @dataType = options.dataType
      @type = options.type

    templateHelpers: =>
      dataType: @dataType
      type: @type
      isExercises: (type, options) ->
        type == 'exercises'
