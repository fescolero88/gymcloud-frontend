define [
  '../entity_templates/view'
  '../entity_templates/item/view'
  'collections/user_collection'
  './template'
], (
  TemplateCollectionView
  TemplateItemView
  UserCollection
  template
)->
  class RootFolderView extends Marionette.CompositeView

    template: template

    className: 'gc-sidebar-cat'

    ui:
      sidebarSubs: '.gc-sidebar-sub'

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

    onRender: ->
      App.request 'sortables:add:container', @ui.sidebarSubs[0]

    _collectionViewOptions: (model) ->
      type: @type
      name: model.get('name')
      collection: model.items

    _itemViewOptions: (model) ->
      attributes:
        'data-category': @name.toLowerCase()
      type: @type
      name: model.get('name')
