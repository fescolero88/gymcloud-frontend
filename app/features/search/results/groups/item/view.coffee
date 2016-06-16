define [
  './templates/entity'
  './templates/clients'
  '../../entities/item/view'
  '../collection'
], (
  templateEntity
  templateClients
  ItemView
  Collection
) ->

  class View extends Marionette.CollectionView

    tagName: 'ul'

    className: 'gc-search-results-list'

    initialize: (opts)->
      @collection = new Collection(opts.model.get('items'))
      @collection.klass = @model.get('klass')

    childView: ItemView

    childViewOptions: ->
      entity_context:
        _.chain(@model.get('klass')).humanize().titleize().pluralize().value()
