define [
  'backbone.marionette'
  './item/view'
  'collections/user_collection'
  './template'
], (
  Marionette
  TemplateCollectionItemView
  UserCollection
  template
)->
  class TemplateCollectionView extends Marionette.CompositeView

    template: template

    className: 'gc-sidebar-cat'

    getChildView: (item) ->
      if typeof item.attributes.folder_id isnt 'undefined'
        TemplateCollectionItemView
      else
        TemplateCollectionView

    childViewOptions: (model, index) ->
      attributes:
        'data-category': @name.toLowerCase()
      type: @type
      name: model.get('name')
      collection: do ->
        if model.items
          new UserCollection(model.get('items'), type)

    childViewContainer: '.gc-sidebar-sub'

    templateHelpers: ->
      type: @type
      name: @name
      isFolder: true

    initialize: (options)->
      @type = options.type
      @name = options.name