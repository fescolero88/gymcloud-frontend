define [
  '../breadcrumbs/view'
  './entity_list/view'
  './add_entity_modal/view'
  './add_folder_modal/view'
  './duplicate_modal/view'
  './template'
], (
  Breadcrumbs
  EntityListView
  AddEntityModalView
  AddFolderModalView
  DuplicateModalView
  template
) ->

  class FolderListView extends Marionette.LayoutView

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
      'click @ui.addExerciseButton': '_showAddEntityModal'
      'click @ui.addExerciseFolderButton': '_showAddFolderModal'
      'click @ui.duplicateButton': '_showDuplicateModal'
      'click @ui.deleteButton': '_destroySelected'

    behaviors: ->

      navigate_back: true
      auto_complete:
        onItemAdd: (id, $item) =>
          Backbone.history.navigate("##{@typeName}/#{id}", trigger: true)
        collection: =>
          App.request('current_user')[@typeName].map (item) ->
            folder: item.folder?.name
            id: item.get('id')
            name: item.get('name')
            label: item.get('name')

    templateHelpers: ->
      type: @typeName
      singularName: @singularName

    initialize: (data) ->
      @exercisesList = data.items
      @collection = data.items
      @typeName = data.type
      @singularName = _.chain(@typeName).humanize().singularize().value()
      @breadcrumbs = new Breadcrumbs(model: @model)

    onShow: ->
      @_showEntityList()
      @getRegion('breadcrumbs').show(@breadcrumbs)

    _showEntityList: ->
      @listView = new EntityListView
        collection: @collection
        type: @typeName
      @exercises.show(@listView)

      @listenTo(@listView, 'item:clicked', @_updateSelectedItems)

      if @exercisesList.length > 0
        @ui.listWrapper.removeClass 'hidden'
      else
        @ui.listWrapper.addClass 'hidden'
        @ui.listSplash.removeClass 'hidden'

    toggleCheck: (ev) =>
      checked = @ui.mainCheckbox.is(':checked')
      @ui.itemsRegion.find('input[type=checkbox]').prop('checked', checked)

    _updateSelectedItems: ->
      for check in @ui.itemsRegion.find('input[type=checkbox]')
        if needToggle?
          if needToggle != $(check).is(':checked')
            @ui.mainCheckbox.prop 'checked', false
            return
        needToggle = $(check).is(':checked')
      if needToggle
        @ui.mainCheckbox.prop 'checked', true

    _destroySelected: (ev) =>
      ev.preventDefault()
      App.request 'base:confirmationalModal',
        title: "Delete item(s)"
        content: "Are you sure you want to delete selected items?"
        confirmBtn: "Delete"
        confirmCallBack: @_onDestroyConfirm

    _onDestroyConfirm: =>
      checked = @ui.itemsRegion.find('input[type=checkbox]:checked')
      ids = checked.map( (_index, el) -> $(el).data('id') ).toArray()
      @listView.trigger('items:delete', ids, @model.get('id'))

    _showAddEntityModal: (ev) ->
      ev.preventDefault()
      view = new AddEntityModalView
        folder: @model
        type: @typeName

      @getRegion('modalRegion').show(view)
      @ui.actionModal.modal('show')

    _showAddFolderModal: (ev) ->
      ev.preventDefault()
      view = new AddFolderModalView
        parent: @model
        type: @typeName

      @getRegion('modalRegion').show(view)
      @ui.actionModal.modal('show')

    _showDuplicateModal: (ev) =>
      ev.preventDefault()
      view = new DuplicateModalView
        collection: @model.nestedFolders
        type: @typeName

      @listenToOnce(view, 'items:duplicate', @_duplicateEntity)

      @modalRegion.show(view)
      @ui.actionModal.modal('show')

    _duplicateEntity: (foldersIds) ->
      checked = @ui.itemsRegion.find('input[type=checkbox]:checked')
      ids = checked.map( (_index, el) -> $(el).data('id') )

      if ids.length and foldersIds.length
        @collection.duplicate(
          ids: ids.toArray()
          foldersIds: foldersIds.toArray()
        ).then(@_onDuplicate)
      else
        App.request 'messenger:show',
          hideAfter: 5
          message: "No #{@singularName} or folder was selected"
          type: 'error'

    _onDuplicate: (response) =>
      @ui.actionModal.modal('hide')
      App.request 'messenger:show',
        hideAfter: 5
        message: "Item(s) duplicated"
        type: 'success'