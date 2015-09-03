define [
  'backbone.marionette'
  'lodash'
  'collections/workout_exercise_properties'
  'models/exercise_property'
  'models/workout_exercise'
  './property/view'
  './template'
], (
  Marionette
  _
  WorkoutExercisesProperties
  ExercisesProperty
  WorkoutExercise
  PropertyView
  template
) ->
  class ExercisesItemView extends Marionette.CompositeView
    template: template

    tagName: 'li'

    className: 'gc-workout-exercise-item hover-enabled'

    childView: PropertyView

    childViewContainer: 'ul.workout-exercise-properties'

    childViewOptions: (model) ->
      properties: @visibleProperties

    ui:
      orderTag: '.gc-workout-exercise-circle'
      deleteBtn: '.gc-delete-exercise'
      addSingleProperty: '.gc-add-single-property-button'
      setPropertyCheckboxWrapper: '.gc-set-property-checkbox-wrapper'
      setPropertyCheckbox: '.gc-set-property-checkbox'
      note: '.gc-workout-exercise-note'

    events:
      'click @ui.orderTag': 'addEditable'
      'blur @ui.orderTag': 'saveOrder'
      'keydown @ui.orderTag': 'saveOnEnter'
      'keyup @ui.orderTag': 'saveOnEnter'
      'click @ui.deleteBtn': 'deleteExercise'
      'click @ui.addSingleProperty': 'addProperty'
      'blur @ui.note': 'onSaveNote'
      'change @ui.setPropertyCheckbox': 'updateConstructorListener'

    initialize: (options) ->
      @visibleProperties = options.visibleProperties
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

    addEditable: (event) ->
      el = event.currentTarget
      el.setAttribute 'contenteditable', true

    saveOnEnter: (event) ->
      label = event.currentTarget.innerHTML.replace /<[^>]*>/g, ''
      if event.keyCode == 13
        event.currentTarget.blur()
        false
      else
        if event.keyCode != 8 and label.trim().length > 2
          event.preventDefault()

    trimLabel: (string) ->
      string
        .replace /[^a-zA-Z0-9]+/g, ''
        .replace /<[^>]*>/g, ''

    saveOrder: (event) ->
      target = event.currentTarget
      label = target.innerHTML = @trimLabel(target.innerHTML)
      target.removeAttribute 'contenteditable'
      @model.save(note: label)

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
      @model.destroy()

    refreshExercises: ->
      App.request 'messenger:show',
        message: "Exercise Updated."
      App.vent.trigger 'workout:reload:exercises'

    addProperty: ->
      default_property = @visibleProperties[0]
      exercise_property = new ExercisesProperty
        workout_exercise_id: @model.get('id')
        personal_property_id: default_property?.id
        personal_property: default_property?.attributes
        position: @collection.length
        'state', 'edit'
      exercise_property.personal_property = default_property
      @collection.add(exercise_property, sort: false)

    processProperties: (models) =>
      promises = []
      if @ui.setPropertyCheckbox.is(':checked')
        models = models.map (property) =>
          promise = property.save(workout_exercise_id: @model.get('id'))
          promises.push promise
          property

        $.when.apply($, promises).done () =>
          @collection.add(models, sort: false)
          App.commands.execute('property_constructor:synced:add')

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

