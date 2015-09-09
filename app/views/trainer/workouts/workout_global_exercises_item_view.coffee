WorkoutExercisesProperties = require 'collections/workout_exercise_properties'
WorkoutExercisesProperty = require 'models/workout_exercise_property'
WorkoutExercise = require 'models/workout_exercise'
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
    note: '.gc-workout-exercise-note'

  initialize: ->
    @collection = new WorkoutExercisesProperties @model.get 'properties'
    @workoutExerciseModel = new WorkoutExercise
    @listenTo @workoutExerciseModel, 'sync', @refreshExercises
    @listenTo @collection, 'change:state', @toggleHover
    @listenTo @collection, 'remove', @toggleHover
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
    'blur @ui.note': 'onSaveNote'
    'change @ui.setPropertyCheckbox': 'updateConstructorListener'

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
    @ui.setPropertyCheckbox.attr 'checked', false
    #enable hover
    @$el.addClass 'hover-enabled'

  updateConstructorListener: (ev) ->
    if $(ev.target).is(':checked')
      App.commands.execute 'property_constructor:update_listeners_count', 1
    else
      App.commands.execute 'property_constructor:update_listeners_count', -1

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
    workoutExerciseProperty = new WorkoutExercisesProperty
    # set default prop here
    workoutExerciseProperty.set 'state', 'edit'
    @collection.add workoutExerciseProperty, sort: false

  processProperties: (models) =>
    promises = []
    if @ui.setPropertyCheckbox.is(':checked')
      models = models.map (property) =>
        model = new WorkoutExercisesProperty
        model.set 'property_value', property.get 'property_value' || 0
        model.set 'property_id', property.get 'property_id' || 0
        model.set 'workout_id', @model.get('workout_id')
        model.set 'workout_exercise_id', @model.get('id')
        promise = model.save()
        promises.push promise
        return model

      $.when.apply($, promises).done () =>
        @collection.add models, sort: false
        App.commands.execute 'property_constructor:synced:add'

  onSaveNote: ->
    data =
      id: @model.get 'workout_id'
      workout_exercise_id: @model.get 'id'
      notes: @ui.note.val()

    @workoutExerciseModel.url = "#{@workoutExerciseModel.urlRoot}/#{data.id}/workout_exercises/#{data.workout_exercise_id}"
    @workoutExerciseModel.set data
    @workoutExerciseModel.save()

  toggleHover: (model, value) ->
    if value is 'edit'
      @$el.removeClass 'hover-enabled'
    else
      @$el.addClass 'hover-enabled'

