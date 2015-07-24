Marionette = require 'backbone.marionette'
WorkoutPropertyCollection = require 'models/trainer/workout-property-collection'
WorkoutPropertyModel = require 'models/trainer/workout-property-model'
WorkoutExerciseModel = require 'models/trainer/workout-exercise-model'
WorkoutGlobalExercisePropertyView = require 'views/trainer/workouts/workout_global_exercise_item_property_view'

module.exports = class ExercisesItemView extends Marionette.CompositeView
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

      models.forEach (property) =>
        model = new WorkoutPropertyModel()
        model.set 'property_value', property.get 'property_value' || 0
        model.set 'property_id', property.get 'property_id' || 0
        model.set 'workout_id', @model.get('workout_id')
        model.set 'workout_exercise_id', @model.get('id')
        model.save(). then =>
          @collection.add model


