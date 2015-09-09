define [
  'backbone.marionette'
  'backbone'
  './item/view'
], (
  Marionette
  Backbone
  EntityItemView
) ->

  class EntityListView extends Marionette.CollectionView

    tagName: 'ul'

    className: 'gc-exercises-assign-list'

    childView: EntityItemView

    childViewContainer: 'ul'

    collectionEvents:
      'sync': 'render'
      'highlight': 'highlightNew'

    ui:
      checkboxWrappers: '.gc-exercises-assign-list'

    childViewOptions: =>
      'type': @typeName

    childEvents:
      'item:clicked': 'itemSelected'

    initialize: (data) =>
      @on 'items:delete', @deleteItems
      @typeName = data.type

    itemSelected: =>
      @trigger 'item:clicked'

    highlightNew: (model) =>
      if model
        $row = @ui.checkboxWrappers.find("[data-id=#{model.id}]").closest('.row')
        $row.addClass 'active'
        $('html, body').animate({
          scrollTop: $row.offset().top
        }, 1000)
        setTimeout ->
            $row.removeClass 'active'
          , 3000

    deleteItems: (ids, rootId) =>
      for key in ids
        model = @collection.where({key: key})[0]
        type = if model.get('isFolder') then "folders" else @typeName
        model.urlRoot = "/api/mobile/#{type}"
        model.idAttribute = "key"
        @notifySidebarChanges model, rootId
        model.destroy()
        App.request('data:reload', @typeName, App.request "data:#{@typeName}:root").then ->
        App.request 'messenger:show',
          hideAfter: 5
          message: "Item(s) was deleted"
          type: 'info'

    notifySidebarChanges: (model, rootId) ->
      folderId = rootId
      rootId = App.request "data:#{@typeName}:root"
      if folderId and folderId isnt 0 and folderId isnt rootId
        App.vent.trigger "#{@typeName}:folder:#{folderId}:model:removed", model
      else
        App.vent.trigger "#{@typeName}:model:removed", model