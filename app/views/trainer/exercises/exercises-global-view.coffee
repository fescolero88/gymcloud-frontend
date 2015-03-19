Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ExercisesGlobalListView = require 'views/trainer/exercises/exercises-global-list-view'

AddExerciseModalView = require 'views/trainer/exercises/add-exercise-modal'
AddExerciseFolderModalView = require 'views/trainer/exercises/add-exercise-folder-modal'
DeplicateExerciseModalView = require 'views/trainer/exercises/duplicate-exercise-modal'
BreadcrumbsView = require 'views/general/breadcrumbs/breadcrumbs-view'
BreadcrumbsCollection = require 'models/general/breadcrumbs'

module.exports = class ExercisesGlobalView extends Marionette.LayoutView

  template: Templates.trainer.exercises.exercises_global

  regions:
    exercises: '#exercises-region'
    modalRegion: '#gc-modal-region'
    breadcrumbsRegion: '#breadcrumbs'

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

  events:
    'click @ui.mainCheckbox': 'toggleCheck'
    'click @ui.addExerciseButton': 'showAddExerciseModal'
    'click @ui.addExerciseFolderButton': 'showAddExerciseFolderModal'
    'click @ui.duplicateButton': 'showDuplicateExerciseModal'
    'click @ui.deleteButton': 'rmAssign'

  initialize: (data) =>
    @item_id = data.model?.get 'key'
    @exercisesList = data.items
    @breadcrumbsView = new BreadcrumbsView
      collection: new BreadcrumbsCollection data.breadcrumbs

    @addExerciseModal = new AddExerciseModalView folderId: @item_id
    @addExerciseFolderModal = new AddExerciseFolderModalView folderId: @item_id
    @duplicateModal = new DeplicateExerciseModalView exercises: @exercisesList
    @listenTo @addExerciseModal, 'exercise:added', @exerciseAdded
    @listenTo @addExerciseFolderModal, 'folder:added', @folderAdded
    @listenTo @duplicateModal, 'exercises:duplicate', @duplicateExercises

  onShow: =>
    @initSearchSelect()
    @loadItemById @item_id
    @breadcrumbsRegion.show @breadcrumbsView

  loadItemById: (key) =>
    @listView = new ExercisesGlobalListView collection: new Backbone.Collection(@exercisesList)
    @listenTo @listView, 'exercise:clicked', @updateSelectedItems
    @exercises.show @listView

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

  searchItems: (items, category) =>
    result = []
    $.each items, (index, item) =>
      if item.items
        category = item.title
        result = result.concat @searchItems(item.items, category)
      else
        result.push
          key: item.key
          title: item.title
          label: category
    return result

  initSearchSelect: =>
    searchOptions = @searchItems App.request('data:exercises'), 'exercises'
    this_ = @
    @ui.liveSearch.selectize
      hideSelected: true
      valueField: 'key'
      labelField: 'title'
      searchField: ['title']
      options: searchOptions
      onItemAdd: (value, $item) ->
        @clear()
        this_.loadItemById value
      render:
        item: (item, escape) ->
            return '<div>' + escape(item.title) + '</div>'
        option: (item, escape) ->
            return '<div><span class="label">' + escape(item.label) +
              '</span> ' + escape(item.title) + '</div>'

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
        @listView.trigger 'items:delete', ids

  loadItem: (key) =>
    @loadItemById key

  showAddExerciseModal: (ev) =>
    ev.preventDefault()
    @modalRegion.show @addExerciseModal
    @ui.actionModal.modal 'show'

  showAddExerciseFolderModal: (ev) =>
    ev.preventDefault()
    @modalRegion.show @addExerciseFolderModal
    @ui.actionModal.modal 'show'

  showDuplicateExerciseModal: (ev) =>
    ev.preventDefault()
    @modalRegion.show @duplicateModal
    @ui.actionModal.modal 'show'

  exerciseAdded: (model) =>
    model['key'] = model['id']
    model['title'] = model['name']
    model['items'] = []
    App.request('data:reload', 'exercises').then =>
      @listView.collection.push model
      @ui.actionModal.modal 'hide'
      App.vent.trigger 'spinner:global:stop'
      App.request 'messenger:show',
        hideAfter: 5
        message: "Exercise added"
        type: 'success'

  folderAdded: (model) =>
    model['key'] = model['id']
    model['title'] = model['name']
    model['items'] = []
    App.request('data:reload', 'exercises').then =>
      @listView.collection.push model
      @ui.actionModal.modal 'hide'
      App.vent.trigger 'spinner:global:stop'
      App.request 'messenger:show',
        hideAfter: 5
        message: "Folder added"
        type: 'success'

  duplicateExercises: (foldersIds) =>
    ids = []
    for check in @ui.itemsRegion.find('input[type=checkbox]')
      if $(check).is ':checked'
        ids.push $(check).data('id')
    if ids.length
      data =
        exercise_ids: ids
        target_folder_ids: foldersIds
      $.ajax
        method: 'POST'
        url: '/api/mobile/exercises/duplicate'
        dataType: 'json'
        data: JSON.stringify data
        success: (data) =>
          App.request('data:reload', 'exercises').then =>
            @ui.actionModal.modal 'hide'
            App.vent.trigger 'spinner:global:stop'
            App.request 'messenger:show',
              hideAfter: 5
              message: "Exercise(s) duplicated"
              type: 'success'
    else
      App.request 'messenger:show',
        hideAfter: 5
        message: "No exercises was selected"
        type: 'error'


