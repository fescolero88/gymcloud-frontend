define [
  'backbone.marionette'
  '../entity_templates/view'
  '../entity_templates/item/view'
  'collections/user_collection'
  './template'
], (
  Marionette
  TemplateCollectionView
  TemplateItemView
  UserCollection
  template
)->
  class RootFolderView extends Marionette.CompositeView

    template: template

    className: 'gc-sidebar-cat'

    getChildView: (item) ->
      if typeof item.attributes.folder_id isnt 'undefined'
        TemplateItemView
      else
        TemplateCollectionView

    childViewContainer: '.gc-sidebar-sub'

    childViewOptions: (model, index) ->
      if model.items
        @_collectionViewOptions(model)
      else
        @_itemViewOptions(model)

    templateHelpers: ->
      type: @type
      name: @name
      isFolder: true

    initialize: (options)->
      @type = options.type
      @name = options.name

    _collectionViewOptions: (model) ->
      type: @type
      name: model.get('name')
      collection: new UserCollection(model.get('items'), @type)

    _itemViewOptions: (model) ->
      attributes:
        'data-category': @name.toLowerCase()
      type: @type
      name: model.get('name')