define [
  './item/view'
  'collections/user_collection'
  './template'
], (
  TemplateCollectionItemView
  UserCollection
  template
)->
  class TemplateCollectionView extends Marionette.CompositeView

    template: template

    className: 'gc-sidebar-folder'

    events:
      'click a:first': '_disableRedirect'

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
      collection: model.items

    childViewContainer: '.gc-sidebar-sub'

    templateHelpers: ->
      type: @type
      name: @name
      isFolder: true

    initialize: (options)->
      @type = options.type
      @name = options.name

    _disableRedirect: (ev) ->
      ev.preventDefault()
