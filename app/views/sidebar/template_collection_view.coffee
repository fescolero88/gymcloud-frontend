define [
  'backbone.marionette'
  'views/sidebar/template_collection_item_view'
  'templates/sidebar/sidebar_item'
], (
  Marionette
  TemplateCollectionItemView
  template
)->
  class TemplateCollectionView extends Marionette.CompositeView

    template: template

    className: 'gc-sidebar-folder'

    getChildView: (item) ->
      if typeof item.attributes.folder_id isnt 'undefined'
        return TemplateCollectionItemView
      else
        return TemplateCollectionView

    childViewOptions: (model, index) ->
      attributes:
        'data-category': @name.toLowerCase()
      type: @type

    childViewContainer: '.gc-sidebar-sub'

    templateHelpers: ->
      type: @type
      name: @name
      isFolder: true

    initialize: (options)->
      @type = options.type
      @name = options.name