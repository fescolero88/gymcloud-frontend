define [
  './item/view'
  './empty/view'
  'dragula'
], (
  EntityItemView
  EntityEmptyView
  Dragula
) ->

  class EntityListView extends Marionette.CollectionView

    tagName: 'ul'

    className: 'gc-exercises-assign-list'

    emptyView: EntityEmptyView

    childView: EntityItemView

    childViewContainer: 'ul'

    collectionEvents:
      'sync': 'render'
      'highlight': 'highlightNew'

    ui:
      checkboxWrappers: '.gc-exercises-assign-list'

    childViewOptions: =>
      'type': @typeName
      'dragula': @dragula

    childEvents:
      'item:clicked': 'itemSelected'
      'folder:change': 'changeFolder'

    viewComparator: (model) ->
      isFolder = model.get('folder_id') is undefined
      [
        isFolder && 1 || 2
        model.get('name')
      ]

    initialize: (data) =>
      @on('items:delete', @_deleteItems)
      @typeName = data.type
      @initDragula()

    initDragula: ->
      options =
        revertOnSpill: true
        accepts: (el, target, source, sibling) ->
          target.classList.contains 'gc-folder'
        moves: (el, source, handle) ->
          el.classList.contains('gc-folder-item')

      @dragula = Dragula [], options

    onShow: ->
      @dragula.containers.push @el

    itemSelected: =>
      @trigger 'item:clicked'

    changeFolder: (view, id) =>
      item = @collection.findWhere 'id': id

      if item
        item.save('folder_id': view.model.get('id'))
          .then =>
            profileModel = App.request 'current_user'
            folder = profileModel.folders.get(view.model.get('id'))
            folder.items.add item
            @collection.remove item

            App.request 'messenger:show',
              hideAfter: 10
              message: "#{item.get('name')} is moved to #{folder.get('name')}."
              type: 'success'

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

    _deleteItems: (ids, rootId) =>
      deletions = _.map ids, (id) =>
        model = @collection.get(id)
        model.destroy(wait: true)
      $.when(deletions...)
        .then ->
          App.request 'messenger:show',
            hideAfter: 5
            message: "Item(s) was deleted"
            type: 'info'
        .fail ->
          App.request 'messenger:show',
            hideAfter: 5
            message: "Some items were not deleted"
            type: 'error'

    notifySidebarChanges: (model, rootId) ->
      folderId = rootId
      rootId = App.request "data:#{@typeName}:root"
      if folderId and folderId isnt 0 and folderId isnt rootId
        App.vent.trigger "#{@typeName}:folder:#{folderId}:model:removed", model
      else
        App.vent.trigger "#{@typeName}:model:removed", model
