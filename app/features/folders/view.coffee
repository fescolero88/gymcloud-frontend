define [
  '../breadcrumbs/view'
  './entity_list/view' #EntityListView
  './add_entity_modal/view' #AddEntityModalView
  './add_folder_modal/view' #AddFolderModalView
  'views/trainer/global_ewp/duplicate-global-ewp-modal' #DuplicateGlobalEWPModalView
  'collections/ewp_sortable' #EWPSortableCollection
  'models/global_ewp_model' #GlobalEWPModel
  './template'
], (
  Breadcrumbs
  EntityListView
  AddEntityModalView
  AddFolderModalView
  DuplicateGlobalEWPModalView
  EWPSortableCollection
  GlobalEWPModel
  template
) ->

  class EWPGlobalView extends Marionette.LayoutView

    template: template

    className: 'gc-global-ewp-wrapper'

    regions:
      exercises: '#exercises-region'
      modalRegion: '#gc-modal-region'
      breadcrumbs: 'region[data-name="breadcrumbs"]'

    ui:
      title: '.gc-breadcrumbs-title'
      liveSearch: '.live-search'
      mainCheckbox: '.gc-content-nav-checkall input'
      backButton: '.gc-content-nav-back'
      itemsRegion: '#exercises-region'
      addExerciseButton: '.gc-show-add-exercise-modal'
      addExerciseFolderButton: '.gc-show-add-exercise-folder-modal'
      duplicateButton: '.gc-show-duplicate-modal'
      actionModal: '#gc-modal-region'
      deleteButton: '#rm-event'
      listWrapper: '.gc-clients-list-wrapper'
      listSplash: '.gc-global-list-splash'

    events:
      'click @ui.mainCheckbox': 'toggleCheck'
      'click @ui.addExerciseButton': 'showAddEntityModal'
      'click @ui.addExerciseFolderButton': 'showAddFolderModal'
      'click @ui.duplicateButton': 'showDuplicateEWPModal'
      'click @ui.deleteButton': 'rmAssign'
      'click @ui.backButton': 'goBack'

    initialize: (data) =>
      @exercisesList = data.items
      @collection = data.items
      @typeName = data.type
      @breadcrumbs = new Breadcrumbs(model: @model)

      @ewpGlobalModel = new GlobalEWPModel type: @typeName
      @listenTo @ewpGlobalModel, 'model:duplicate:success', @onDuplicate

    templateHelpers: ->
      type: @typeName
      singularName: _.chain(@typeName).humanize().singularize().value()

    onShow: =>
      @initSearchSelect()
      @loadItemById @model.get('id')
      @getRegion('breadcrumbs').show(@breadcrumbs)

    loadItemById: (key) =>
      @listView = new EntityListView
        collection: @collection
        type: @typeName
      @exercises.show(@listView)

      @listenTo @listView, 'item:clicked', @updateSelectedItems

      if @exercisesList.length > 0
        @ui.listWrapper.removeClass 'hidden'
      else
        @ui.listWrapper.addClass 'hidden'
        @ui.listSplash.removeClass 'hidden'

    toggleCheck: (ev) =>
      checked = @ui.mainCheckbox.is(':checked')
      @ui.itemsRegion.find('input[type=checkbox]').prop('checked', checked)

    updateSelectedItems: =>
      for check in @ui.itemsRegion.find('input[type=checkbox]')
        if needToggle?
          if needToggle != $(check).is(':checked')
            @ui.mainCheckbox.prop 'checked', false
            return
        needToggle = $(check).is(':checked')
      if needToggle
        @ui.mainCheckbox.prop 'checked', true

    _searchItems: (collection) ->
      collection.map (item) ->
        id: item.get('id')
        title: item.get('name')
        label: item.folder.get('name')

    initSearchSelect: =>
      user = App.request('current_user')
      collection = user[@typeName]
      this_ = @
      @ui.liveSearch.selectize
        hideSelected: true
        valueField: 'id'
        labelField: 'title'
        searchField: ['title']
        options: @_searchItems(collection)
        onItemAdd: (id, $item) =>
          Backbone.history.navigate("##{@typeName}/#{id}", trigger: true)
        render:
          item: (item, escape) ->
            "<div>#{escape(item.title)}</div>"
          option: (item, escape) ->
            label = "<span class=\"label\">#{escape(item.label)}</span> "
            "<div>#{label}#{escape(item.title)}</div>"

    rmAssign: (ev) =>
      ev.preventDefault()
      App.request 'base:confirmationalModal',
        title: "Delete item(s)"
        content: "Are you sure you want to delete selected items?"
        confirmBtn: "Delete"
        confirmCallBack: =>
          ids = []
          for check in @ui.itemsRegion.find('input[type=checkbox]')
            if $(check).is ':checked'
              ids.push $(check).data('id')
          @listView.trigger 'items:delete', ids, @model.get('id')
          App.request('data:reload', @typeName, App.request "data:#{@typeName}:root").then =>
            @exercisesList = App.request "data:#{@typeName}"

    showAddEntityModal: (ev) ->
      ev.preventDefault()
      view = new AddEntityModalView
        folder: @model
        type: @typeName

      @getRegion('modalRegion').show(view)
      @ui.actionModal.modal('show')

    showAddFolderModal: (ev) ->
      ev.preventDefault()
      view = new AddFolderModalView
        parent: @model
        type: @typeName

      @getRegion('modalRegion').show(view)
      @ui.actionModal.modal('show')

    showDuplicateEWPModal: (ev) =>
      ev.preventDefault()
      @duplicateGlobalEWPModal = new DuplicateGlobalEWPModalView
        items: @exercisesList
        type: @typeName

      @listenTo @duplicateGlobalEWPModal, 'items:duplicate', @duplicateEWP

      @modalRegion.show @duplicateGlobalEWPModal
      @ui.actionModal.modal 'show'

    # exerciseAdded: (model) =>
    #   model['key'] = model['id']
    #   model['title'] = model['name']
    #   model['items'] = []
    #   model['isFolder'] = false
    #   @showListIfHidden()
    #   App.request('data:reload', @typeName, App.request "data:#{@typeName}:root").then =>
    #     @ui.actionModal.modal 'hide'
    #     @listView.collection.push model
    #     @listView.collection.comparator = (model) =>
    #       return [not model.get('isFolder'), model.get('title').toUpperCase()]
    #     @listView.collection.sort()
    #     @listView.render()
    #     @listView.collection.trigger 'highlight', model
    #     href = "#tr/global/#{@typeName}/id/#{model['key']}"
    #     App.vent.trigger ''
    #
    #     # notify sidebar changes
    #     @notifySidebarChanges model
    #
    #     App.request 'messenger:show',
    #       hideAfter: 5
    #       message: "New item added"
    #       type: 'success'

    # folderAdded: (model) =>
    #   model['key'] = model['id']
    #   model['title'] = model['name']
    #   model['items'] = []
    #   model['isFolder'] = true
    #   @showListIfHidden()
    #   App.request('data:reload', @typeName, App.request "data:#{@typeName}:root").then =>
    #     @ui.actionModal.modal 'hide'
    #     # retrieve new data
    #     @exercisesList = App.request "data:#{@typeName}"
    #     @listView.collection.push model
    #     @listView.collection.comparator = (model) =>
    #       return [not model.get('isFolder'), model.get('title').toUpperCase()]
    #     @listView.collection.sort()
    #     @listView.render()
    #     @listView.collection.trigger 'highlight', model
    #     href = "#tr/global/#{@typeName}/id/#{model['key']}"
    #     App.vent.trigger ''
    #     @notifySidebarChanges model

    duplicateEWP: (foldersIds) =>
      ids = []
      for check in @ui.itemsRegion.find('input[type=checkbox]')
        if $(check).is ':checked'
          ids.push $(check).data('id')
      if ids.length
        type = @typeName.substring(0, @typeName.length - 1)
        data =
          target_folder_ids: foldersIds
        data["#{type}_ids"] = ids
        @ewpGlobalModel.duplicate(data)
      else
        typeSingle = @typeName.substring 0, @typeName.length - 1
        App.request 'messenger:show',
          hideAfter: 5
          message: "No #{typeSingle} was selected"
          type: 'error'

    onDuplicate: (response) ->
      App.request('data:reload', @typeName, App.request "data:#{@typeName}:root").then =>
        @ui.actionModal.modal 'hide'
        App.vent.trigger ''
        App.request 'messenger:show',
          hideAfter: 5
          message: "Item(s) duplicated"
          type: 'success'

      ## notify sidebar of duplicated items
      response.target_folders.forEach (item) =>
        folderId = item.target_folder_id
        item["#{@typeName}"].forEach (entity) =>
          entityId = entity.exercise_id || entity.workout_id || entity.program_id
          model = @collection.where({key: entityId})
          App.vent.trigger "#{@typeName}:folder:#{folderId}:model:added", model

    goBack: (ev) ->
      ev.preventDefault()
      window.history.back()

    showListIfHidden: ->
      if @ui.listWrapper.hasClass 'hidden'
        @ui.listWrapper.removeClass 'hidden'
        @ui.listSplash.addClass 'hidden'

    notifySidebarChanges: (model) ->
      folderId = model.workout_folder_id || model.exercise_folder_id || model.program_folder_id || model.parent_id
      rootId = App.request "data:#{@typeName}:root"
      if folderId and folderId isnt 0 and folderId isnt rootId
        App.vent.trigger "#{@typeName}:folder:#{folderId}:model:added", new Backbone.Model model
      else
        App.vent.trigger "#{@typeName}:model:added", new Backbone.Model model
