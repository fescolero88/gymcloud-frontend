define [
  './item/view'
  './empty/view'
], (
  ItemView
  EmptyView
) ->

  class ProgramWeeksListView extends Marionette.CollectionView

    className: 'gc-programs-weeks-list-container'

    emptyView: EmptyView

    childView: ItemView

    viewComparator: (model) ->
      model.get 'position'

    initialize: ->
      @collection = new Backbone.VirtualCollection @options.collection
      @collection.program_template = @options.collection.program_template
      @listenTo @, 'all', -> console.log @cid, arguments
