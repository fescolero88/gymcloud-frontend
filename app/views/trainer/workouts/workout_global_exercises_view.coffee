_ = require 'lodash'
Marionette = require 'backbone.marionette'
Backbone = require 'backbone'
WorkoutPropertyConstructor = require 'views/trainer/workouts/workout_property_constructor_view'
WorkoutPropertyCollection = require 'models/trainer/workout-property-collection'
WorkoutPropertyModel = require 'models/trainer/workout-property-model'
PropertyCollection = require 'models/trainer/property-collection'

WorkoutExerciseModel = require 'models/trainer/workout-exercise-model'

class EmptyView extends Marionette.ItemView
  template: require('templates/trainer/workouts/workout_global_exercises_empty')

# EXERCISE PROPERTIES VIEW
class WorkoutGlobalExercisePropertyView extends Marionette.ItemView

  template: require 'templates/trainer/workouts/workout_global_exercise_property'

  tagName: 'li'
  className: 'gc-property-item'

  templateHelpers: ->
    @properties = @collection.toJSON()
    editMode: @state is 'edit'
    properties: @properties
    defaultProperty: @properties[0]?.name
    defaultPropertyValue: @properties[0]?.defaultvalue

  ui:
    removePropertyButton: '.gc-remove'
    propertyItem: '.gc-property-item'
    selectedPropertyLabel: '.gc-selected-property'
    selectedPropertyValue: '.gc-property-value'
    propertyValueNameLabel: '.gc-property-value-name-label'
    editPropertyControl: '.gc-property-edit'
    viewPropertyControl: '.gc-property-view'
    toggleEditMode: '.gc-toggle-edit-mode'

  events:
    'click @ui.removePropertyButton': 'removeProperty'
    'click @ui.propertyItem': 'selectProperty'
    'blur @ui.selectedPropertyValue': 'saveProperty'
    'click @ui.toggleEditMode': 'toggleEditMode'

  collectionEvents:
    sync: 'render'

  modelEvents:
    sync: 'onSync'

  initialize: (options) ->
    @properties = []
    @selectedPropertyId = ''
    @collection = new PropertyCollection()
    @collection.fetch()
    @model.set 'property_value', @model.get('value')
    @model.set 'property_name', @model.get('name')
    @state = @model.get('state') || 'view'

  onRender: ->
    #set default property id
    if @model.isNew()
      @model.set 'property_id', @properties[0]?.id
      @model.set 'property_value', @properties[0]?.defaultvalue
      @model.set 'property_name', @properties[0]?.name

  removeProperty: ->
    @model.destroy()

  selectProperty: (ev) ->
    ev.preventDefault()
    console.log ev.target
    @ui.selectedPropertyLabel.html(ev.currentTarget.innerHTML)
    @ui.selectedPropertyValue.html(ev.currentTarget.dataset.defaultValue)
    @model.set 'property_value', ev.target.dataset.defaultValue
    @model.set 'property_name', ev.target.innerHTML
    @model.set 'property_id', ev.target.dataset.id

  toggleEditMode: (e) ->
    console.log 'model', @model
    e.preventDefault()
    @model.get('state', 'edit')
    @ui.selectedPropertyLabel.html @model.get('property_name')
    @ui.selectedPropertyValue.html @model.get('property_value')
    @ui.editPropertyControl.removeClass 'hidden'
    @ui.viewPropertyControl.addClass 'hidden'

  saveProperty: (e) ->
    @model.set 'property_value', e.target.innerHTML
    @model.save()
    @model.set 'state', 'view'

  onSync: =>
    @ui.propertyValueNameLabel.html "#{@model.get 'property_value'} #{@model.get 'property_name'}"
    @ui.editPropertyControl.addClass 'hidden'
    @ui.viewPropertyControl.removeClass 'hidden'

# EXECISES ITEM VIEW
class ExercisesItemView extends Marionette.CompositeView
  template: require('templates/trainer/workouts/workout_global_exercise_item')

  tagName: 'li'

  className: 'gc-workout-exercise-item hover-enabled'

  childView: WorkoutGlobalExercisePropertyView

  childViewContainer: 'ul.workout-exercise-properties'

  childViewOptions: (model) ->
    model.set 'workout_id', @model.get('workout_id')
    model.set 'workout_exercise_id', @model.get('id')
    
    model

  ui:
    orderTag: '.gc-workout-exercise-circle'
    deleteBtn: '.gc-delete-exercise'
    addSingleProperty: '.gc-add-single-property-button'
    setPropertyCheckboxWrapper: '.gc-set-property-checkbox-wrapper'
    setPropertyCheckbox: '.gc-set-property-checkbox'

  initialize: ->
    @collection = new WorkoutPropertyCollection @model.get 'properties'
    @workoutExerciseModel = new WorkoutExerciseModel
    @listenTo @workoutExerciseModel, 'sync', @refreshExercises

    App.vent.on 'exercise_property:select:enable', @enableCheckbox
    App.vent.on 'exercise_property:select:disable', @disableCheckbox
    App.vent.on 'exercise_property:assign', @processProperties

  onDestroy: ->
    App.vent.off 'exercise_property:select:enable', @enableCheckbox
    App.vent.off 'exercise_property:select:disable', @disableCheckbox
    App.vent.off 'exercise_property:assign', @processProperties

  events:
    'click @ui.orderTag': 'addEditable'
    'blur @ui.orderTag': 'saveOrder'
    'keydown @ui.orderTag': 'saveOnEnter'
    'keyup @ui.orderTag': 'saveOnEnter'
    'click @ui.deleteBtn': 'deleteExercise'
    'click @ui.addSingleProperty': 'addProperty'

  addEditable: (event) ->
    el = event.currentTarget
    el.setAttribute 'contenteditable', true

  saveOnEnter: (event) =>
    label = event.currentTarget.innerHTML.replace /<[^>]*>/g, ''
    if event.keyCode == 13
      event.currentTarget.blur()
      false
    else
      if event.keyCode != 8 and label.trim().length > 2
        event.preventDefault()

  trimLabel: (target) ->
    label = target.innerHTML.replace /[^a-zA-Z0-9]+/g, ''
    target.innerHTML = label

  saveOrder: (event) ->
    @trimLabel(event.currentTarget)

    event.currentTarget.removeAttribute 'contenteditable'
    label = event.currentTarget.innerHTML.replace /<[^>]*>/g, ''
    data =
      id: @model.get 'workout_id'
      workout_exercise_id: @model.get 'id'
      label: label

    @workoutExerciseModel.url = "#{@workoutExerciseModel.urlRoot}/#{data.id}/workout_exercises/#{data.workout_exercise_id}"
    @workoutExerciseModel.set data
    @workoutExerciseModel.save()

  enableCheckbox: =>
    @ui.setPropertyCheckboxWrapper.removeClass 'hidden'
    #disable hover
    @$el.removeClass 'hover-enabled'

  disableCheckbox: =>
    @ui.setPropertyCheckboxWrapper.addClass 'hidden'
    #enable hover
    @$el.addClass 'hover-enabled'

  deleteExercise: (event) ->
    event.preventDefault()
    data =
      id: @model.get 'workout_id'
      workout_exercise_id: @model.get 'id'
    @workoutExerciseModel.url = "#{@workoutExerciseModel.urlRoot}/#{data.id}/workout_exercises/#{data.workout_exercise_id}"
    @workoutExerciseModel.set data
    @workoutExerciseModel.destroy()

  refreshExercises: ->
    App.request 'messenger:show',
      message: "Exercise Updated."
    App.vent.trigger 'workout:reload:exercises'

  addProperty: ->
    workoutProperty = new WorkoutPropertyModel()
    workoutProperty.set 'state', 'edit'
    @collection.add workoutProperty

  processProperties: (models) =>
    if @ui.setPropertyCheckbox.is(':checked')
      console.log 'props processing', models
      deferreds = []
      models.forEach (property) =>
        model = new WorkoutPropertyModel(property)
        model.set 'workout_id', @model.get('workout_id')
        model.set 'workout_exercise_id', @model.get('id')
        console.log 'model is being pushed', model
        deferreds.push model

      $.when.apply($, deferreds).then =>
        @collection.add deferreds

      # save models
      deferreds.forEach (property) =>
        console.log 'saving', property
        property.save()

module.exports = class WorkoutGlobalExercisesView extends Marionette.CompositeView

  template: require('templates/trainer/workouts/workout_global_exercises')

  className: 'gc-workouts-exercises-view'

  emptyView: EmptyView

  childView: ExercisesItemView

  childViewOptions: (model) ->
    model.set 'workout_id', @workout.get 'id'
    return model

  childViewContainer: 'ul'

  ui:
    circles: '.gc-workout-exercise-circle'
    liveSearch: '.live-search'
    searchContainer: '.gc-exercises-assign-input-wrapper'
    propertyConstructorWrapper: 'region[data-name="workout-property-constructor"]'

  templateHelpers: =>
    workout: @workout.attributes

  initialize: (data) =>
    @workout = data.workout
    @on 'render:collection', @showConnectionLines
    App.vent.on 'workout:reload:exercises', @getWorkoutData

    @workoutExerciseModel = new WorkoutExerciseModel
    @listenTo @workoutExerciseModel, 'sync', @onSavedOrder
    @listenTo @workout, 'sync', @resetExercises

  onDestroy: ->
    App.vent.off 'workout:reload:exercises', @getWorkoutData

  onRender: ->
    workoutPropertyConstructor = new WorkoutPropertyConstructor
      collection: new WorkoutPropertyCollection()

    @ui.propertyConstructorWrapper.html workoutPropertyConstructor.render().el

    @initSearchSelect()
    @addSortable()

  getWorkoutData: =>
    @workout.fetch()

  resetExercises: ->
    @collection.reset()
    @collection.set @workout.get('exercises')
    @render()

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

  initSearchSelect: ->
    searchOptions = @searchItems App.request("data:exercises"), 'exercises'
    this_ = @
    @ui.liveSearch.selectize
      hideSelected: true
      valueField: 'key'
      labelField: 'title'
      searchField: ['title']
      options: searchOptions
      onItemAdd: (value, $item) ->
        this_.removeSearchValues()
        this_.addExercise value, $item
      render:
        item: (item, escape) ->
            return '<div>' + escape(item.title) + '</div>'
        option: (item, escape) ->
            return '<div><span class="label">' + escape(item.label) +
              '</span> ' + escape(item.title) + '</div>'

  showConnectionLines: =>
    circles = @$el.find(".gc-workout-exercise-circle[data-letter]")
    colors = [
      '#38cb73'
      '#389adb'
      '#fed929'
      '#e54d40'
      '#e459fe'
    ]
    groupColors = {}
    colorIndex = 0
    previous = null

    $.each circles, (index, item) =>
        $item = $ item
        letter = $item.data('letter').toLowerCase()
        $item[0].className = 'gc-workout-exercise-circle'

        if previous

          if previous.data('letter').toLowerCase() == letter and letter != ''
            $item.addClass 'last'

            if previous.hasClass 'last'
              previous.removeClass('last').addClass('middle')
            else
              previous.addClass('first')

          else
            $item.removeClass('last')
            previous.removeClass('middle').removeClass('first')

        if groupColors.hasOwnProperty(letter)
          $item.css 'background-color', groupColors[letter]
        else
          groupColors[letter] = colors[colorIndex]
          $item.css 'background-color', groupColors[letter]
          colorIndex++

        previous = $item

  addSortable: ->
    @exerciseList = @$el.find '.gc-workout-exercises-list'

    @exerciseList.sortable
      pullPlaceholder: true
      handle: '.gc-workout-exercise-sort'
      onDrop: @onSortExercise
      onDragStart: @onDragStart

  onDragStart: ($item, container, _super) =>
    if not container.options.drop
      $item.clone().insertAfter($item)
      $item
      .removeClass 'dragged'
      .removeAttr 'style'
    _super $item, container

  onSortExercise: ($item, container, _super) =>
    draggable = $item.find 'span.gc-workout-exercise-sort'
    _super $item, container

    model = @collection.get id: draggable.data 'workout-id'
    prevPos = model.get 'position'
    currPos = $item.index()
    currPos += 1
    @collection.remove model
    @collection.add model, at:currPos-1
    @fixExercisesPositions()

    exerciseIds = @collection.pluck 'id'
    @onSavePosition
      exercises_ordered_ids: exerciseIds

  fixExercisesPositions: ->
    @collection.each (model, i) =>
      model.set 'position', i+1

  onSavePosition: (data) =>
    @workoutExerciseModel.url = "#{@workoutExerciseModel.urlRoot}/#{@workout.get 'id'}/workout_exercises/resort"
    @workoutExerciseModel.method = 'patch'
    @workoutExerciseModel.save data, patch: true

  onSavedOrder: ->
    App.request 'messenger:show',
      hideAfter: 5
      message: "Order Position Saved."
      type: 'success'

    @showConnectionLines()

  addExercise: (value, $item) =>
    data =
      category: 'exercises'
      id: value
    App.vent.trigger 'workout:add:exercise', data

  removeSearchValues: ->
    selectiveIput = @$el.find '.selectize-input'
    selectiveIput.find('div').remove()
