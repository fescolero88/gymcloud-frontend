define [
  './template'
], (
  emptyTemplate
) ->

  class EmptyView extends Marionette.ItemView

    template: emptyTemplate

    initialize: (data) =>
      @dataType = data.dataType

    templateHelpers: =>
      dataType: @dataType
