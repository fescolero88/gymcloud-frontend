define [
  './item/view'
  './collection'
], (
  ProgramPresetItemView
  ProgramPresetsCollection
) ->
  class ProgramPresetListView extends Marionette.CollectionView

    tagName: 'ul'

    childView: ProgramPresetItemView

    initialize: ->
      @collection = new ProgramPresetsCollection
      @collection.fetch()
