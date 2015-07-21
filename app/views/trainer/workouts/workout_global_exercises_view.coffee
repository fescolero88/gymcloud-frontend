_ = require 'lodash'
Marionette = require 'backbone.marionette'
Backbone = require 'backbone'
WorkoutPropertyConstructor = require 'views/trainer/workouts/workout_property_constructor_view'
WorkoutPropertyCollection = require 'models/trainer/workout-property-collection'

WorkoutExerciseModel = require 'models/trainer/workout-exercise-model'

class EmptyView extends Marionette.ItemView
  template: require('templates/trainer/workouts/workout_global_exercises_empty')

class ExercisesItemView extends Marionette.ItemView
  template: require('templates/trainer/workouts/workout_global_exercise_item')

  tagName: 'li'

  ui:
    orderTag: '.gc-workout-exercise-circle'
    deleteBtn: '.gc-delete-exercise'

  initialize: ->
    @workoutExerciseModel = new WorkoutExerciseModel
    @listenTo @workoutExerciseModel, 'sync', @refreshExercises

  events:
    'click @ui.orderTag': 'addEditable'
    'blur @ui.orderTag': 'saveOrder'
    'keydown @ui.orderTag': 'saveOnEnter'
    'click @ui.deleteBtn': 'deleteExercise'

  addEditable: (event) ->
    el = event.currentTarget
    el.setAttribute 'contenteditable', true

  saveOnEnter: (event) =>
    if event.keyCode == 13
      @saveOrder()
      event.preventDefault()

  saveOrder: (event) ->
    event.currentTarget.removeAttribute 'contenteditable'
    data =
      id: @model.get 'workout_id'
      workout_exercise_id: @model.get 'id'
      position: 1
      order_name: 1

    @workoutExerciseModel.url = "#{@workoutExerciseModel.urlRoot}/#{data.id}/workout_exercises/#{data.workout_exercise_id}"
    @workoutExerciseModel.set data
    @workoutExerciseModel.save()

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
    App.vent.on 'workout:reload:exercises', =>
      @workout.fetch()

    @workoutExerciseModel = new WorkoutExerciseModel
    @listenTo @workoutExerciseModel, 'sync', @onSavedOrder

  onRender: ->
    workoutPropertyConstructor = new WorkoutPropertyConstructor
      collection: new WorkoutPropertyCollection()

    @ui.propertyConstructorWrapper.html workoutPropertyConstructor.render().el

    @initSearchSelect()
    @addSortable()

  getWorkoutData: ->
    @workout.fetch()

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
    previous = null
    $.each circles, (index, item) =>
        $item = $ item
        letter = $item.data 'letter'

        if letter
          if previous and previous.data 'letter' == letter
            $item.addClass 'last'
            if previous.hasClass 'last'
              previous.removeClass('last').addClass('middle')
            else
              previous.addClass('first')

          previousLetter = letter

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

  addExercise: (value, $item) =>
    data =
      category: 'exercises'
      id: value
    App.vent.trigger 'workout:add:exercise', data

  removeSearchValues: ->
    selectiveIput = @$el.find '.selectize-input'
    selectiveIput.find('div').remove()
