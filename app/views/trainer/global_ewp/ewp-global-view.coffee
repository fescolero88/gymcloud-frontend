Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

EWPGlobalListView = require 'views/trainer/global_ewp/ewp-global-list-view'

AddGlobalEWPModalView = require 'views/trainer/global_ewp/add-global-ewp-modal'
AddGlobalFolderModalView = require 'views/trainer/global_ewp/add-global-folder-modal'
DuplicateGlobalEWPModalView = require 'views/trainer/global_ewp/duplicate-global-ewp-modal'

BreadcrumbsView = require 'views/general/breadcrumbs/breadcrumbs-view'
BreadcrumbsCollection = require 'models/general/breadcrumbs'
EWPSortableCollection = require 'models/trainer/ewp_sortable_collection'

GlobalEWPModel = require 'models/trainer/global-ewp-model'

module.exports = class EWPGlobalView extends Marionette.LayoutView

  template: require('templates/trainer/global_ewp/global_ewp_layout')

  className: 'gc-global-ewp-wrapper'

  regions:
    exercises: '#exercises-region'
    modalRegion: '#gc-modal-region'
    breadcrumbsRegion: '#breadcrumbs'

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
    'click @ui.addExerciseButton': 'showaddGlobalEWPModal'
    'click @ui.addExerciseFolderButton': 'showaddGlobalFolderModal'
    'click @ui.duplicateButton': 'showDuplicateEWPModal'
    'click @ui.deleteButton': 'rmAssign'
    'click @ui.backButton': 'goBack'

  initialize: (data) =>
    #console.log 'global view model', @model
    @item_id = data.model?.get 'key'
    @exercisesList = data.items
    @typeName = data.type
    @breadcrumbsView = new BreadcrumbsView
      collection: new BreadcrumbsCollection data.breadcrumbs

    @ewpGlobalModel = new GlobalEWPModel type: @typeName
    @listenTo @ewpGlobalModel, 'model:duplicate:success', @onDuplicate

    @initializeFolderModal()
    @initializeDuplicateModal()
    @initializeEWPModal()

  initializeFolderModal: ->
    @addGlobalFolderModal = new AddGlobalFolderModalView
      folderId: @item_id
      type: @typeName
    @listenTo @addGlobalFolderModal, 'folder:added', @folderAdded

  initializeDuplicateModal: ->
    @duplicateGlobalEWPModal = new DuplicateGlobalEWPModalView
      items: @exercisesList
      type: @typeName
    @listenTo @duplicateGlobalEWPModal, 'items:duplicate', @duplicateEWP

  initializeEWPModal: ->
    @addGlobalEWPModal = new AddGlobalEWPModalView
      folderId: @item_id
      type: @typeName
      modalEntity: $("#gc-modal-region")
    @listenTo @addGlobalEWPModal, 'item:added', @exerciseAdded

  templateHelpers: ->
    type: @typeName
    typeSingle: @typeName.substring(0, @typeName.length - 1)

  onShow: =>
    @initSearchSelect()
    @loadItemById @item_id
    @breadcrumbsRegion.show @breadcrumbsView

    unless @breadcrumbsView.collection.length > 1
      @ui.backButton.addClass 'hidden'

  loadItemById: (key) =>
    @listView = new EWPGlobalListView
      collection: new EWPSortableCollection(@exercisesList)
      type: @typeName
    @exercises.show @listView

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

  searchItems: (items, category) =>
    result = []
    $.each items, (index, item) =>
      if not item
        return true
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
    searchOptions = @searchItems App.request("data:#{@typeName}"), @typeName
    this_ = @
    @ui.liveSearch.selectize
      hideSelected: true
      valueField: 'key'
      labelField: 'title'
      searchField: ['title']
      options: searchOptions
      onItemAdd: (value, $item) ->
        this_.loadItem value
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
    Backbone.history.navigate("#tr/global/#{@typeName}/id/#{key}/", { trigger: true, replace: true })

  showaddGlobalEWPModal: (ev) =>
    ev.preventDefault()
    @initializeEWPModal() if @addGlobalEWPModal.isDestroyed
    @modalRegion.show @addGlobalEWPModal
    @ui.actionModal.modal 'show'

  showaddGlobalFolderModal: (ev) =>
    ev.preventDefault()
    @initializeFolderModal() if @addGlobalFolderModal.isDestroyed
    @modalRegion.show @addGlobalFolderModal
    @ui.actionModal.modal 'show'

  showDuplicateEWPModal: (ev) =>
    ev.preventDefault()
    @initializeDuplicateModal() if @duplicateGlobalEWPModal.isDestroyed
    @modalRegion.show @duplicateGlobalEWPModal
    @ui.actionModal.modal 'show'

  exerciseAdded: (model) =>
    model['key'] = model['id']
    model['title'] = model['name']
    model['items'] = []
    model['isFolder'] = false
    @showListIfHidden()
    App.request('data:reload', @typeName, App.request "data:#{@typeName}:root").then =>
      @ui.actionModal.modal 'hide'
      @listView.collection.push model
      @listView.collection.comparator = (model) =>
        return [not model.get('isFolder'), model.get('title').toUpperCase()]
      @listView.collection.sort()
      @listView.render()
      @listView.collection.trigger 'highlight', model
      href = "#tr/global/#{@typeName}/id/#{model['key']}"
      App.vent.trigger 'spinner:global:stop'
      App.request 'messenger:show',
        hideAfter: 5
        message: "New item added"
        type: 'success'

  folderAdded: (model) =>
    model['key'] = model['id']
    model['title'] = model['name']
    model['items'] = []
    model['isFolder'] = true
    @showListIfHidden()
    App.request('data:reload', 'exercises', App.request 'data:exercises:root').then =>
      @ui.actionModal.modal 'hide'
      @listView.collection.push model
      @listView.collection.comparator = (model) =>
        return [not model.get('isFolder'), model.get('title').toUpperCase()]
      @listView.collection.sort()
      @listView.render()
      @listView.collection.trigger 'highlight', model
      href = "#tr/global/#{@typeName}/id/#{model['key']}"
      App.vent.trigger 'spinner:global:stop'
      App.request 'messenger:show',
        hideAfter: 5
        message: "New folder added"
        type: 'success'

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

  onDuplicate: ->
    App.request('data:reload', @typeName, App.request "data:#{@typeName}:root").then =>
      @ui.actionModal.modal 'hide'
      App.vent.trigger 'spinner:global:stop'
      App.request 'messenger:show',
        hideAfter: 5
        message: "Item(s) duplicated"
        type: 'success'

  goBack: (ev) ->
    ev.preventDefault()
    window.history.back()

  showListIfHidden: ->
    if @ui.listWrapper.hasClass 'hidden'
      @ui.listWrapper.removeClass 'hidden'
      @ui.listSplash.addClass 'hidden'
