Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ExercisesGlobalListView = require 'views/trainer/exercises/exercises-global-list-view'

AddExerciseModalView = require 'views/trainer/exercises/add-exercise-modal'
AddExerciseFolderModalView = require 'views/trainer/exercises/add-exercise-folder-modal'
DeplicateExerciseModalView = require 'views/trainer/exercises/duplicate-exercise-modal'

module.exports = class ExercisesGlobalView extends Marionette.LayoutView

  template: Templates.trainer.exercises.exercises_global

  regions:
    exercises: '#exercises-region'
    modalRegion: '#gc-modal-region'

  ui:
    title: '.gc-breadcrumbs-title'
    liveSearch: '.live-search'
    mainCheckbox: '.gc-content-nav-checkall input'
    itemsRegion: '#exercises-region'
    addExerciseButton: '.gc-show-add-exercise-modal'
    addExerciseFolderButton: '.gc-show-add-exercise-folder-modal'
    duplicateButton: '.gc-show-duplicate-modal'
    actionModal: '#gc-modal-region'

  events:
    'click @ui.mainCheckbox': 'toggleCheck'
    'click @ui.addExerciseButton': 'showAddExerciseModal'
    'click @ui.addExerciseFolderButton': 'showAddExerciseFolderModal'
    'click @ui.duplicateButton': 'showDuplicateExerciseModal'

  initialize: (data) =>
    @item_id = data.id

  onShow: =>
    @exercisesList = App.request 'data:exercises'
    if @exercisesList?.length
      @initSearchSelect()
    else
      App.vent.on 'assignments:loaded', @loadExercises
    @loadItemById @item_id
    if not @item_id
      @updateBreadcrumbs(['Exercises'])
    @exercises.show @listView

  onDestroy: =>
    App.vent.off 'assignments:loaded', @loadExercises

  loadItemById: (key) =>
    @listView = new ExercisesGlobalListView(id: key)
    @listenTo @listView, 'breadcrumbs:change', @updateBreadcrumbs
    @listenTo @listView, 'exercise:clicked', @updateSelectedItems
    @listenTo @listView, 'navigate:exercise', @navigateToItem
    @exercises.show @listView

  loadExercises: =>
    @exercisesList = App.request 'data:exercises'
    @initSearchSelect()

  updateBreadcrumbs: (breadcrumbs) =>
    @ui.title.text('')
    $.each breadcrumbs, (index, value) =>
      @ui.title.append $("<span>#{value}</span>")

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

  navigateToItem: (href, key) =>
    Backbone.history.navigate(href, { trigger:false, replace: true })
    @loadItemById key

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
    searchOptions = @searchItems @exercisesList, 'exercises'
    this_ = @
    @ui.liveSearch.selectize
      hideSelected: true
      valueField: 'key'
      labelField: 'title'
      searchField: ['title']
      options: searchOptions
      onItemAdd: (value, $item) ->
        @clear()
        this_.loadItem value
      render:
        item: (item, escape) ->
            return '<div>' + escape(item.title) + '</div>'
        option: (item, escape) ->
            return '<div><span class="label">' + escape(item.label) +
              '</span> ' + escape(item.title) + '</div>'

  loadItem: (key) =>
    @loadItemById key

  showAddExerciseModal: (ev) =>
    ev.preventDefault()
    @modalRegion.show new AddExerciseModalView
    @ui.actionModal.modal 'show'

  showAddExerciseFolderModal: (ev) =>
    ev.preventDefault()
    @modalRegion.show new AddExerciseFolderModalView
    @ui.actionModal.modal 'show'

  showDuplicateExerciseModal: (ev) =>
    ev.preventDefault()
    duplicateView = new DeplicateExerciseModalView
      exercises: @exercisesList
    @modalRegion.show duplicateView
    @ui.actionModal.modal 'show'

