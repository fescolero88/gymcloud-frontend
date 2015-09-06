define [
  'backbone.marionette'
  'models/exercise_property'
  'collections/properties'
  './item/view'
  './template'
], (
  Marionette
  ExerciseProperty
  Properties
  WorkoutExercisePropertyItem
  template
) ->
  class WorkoutExercisePropertyConstructor extends Marionette.CompositeView

    template: template

    childView: WorkoutExercisePropertyItem

    childViewContainer: 'ul.gc-workout-exercise-property-list'

    collectionEvents:
      remove: 'onModelRemoved'

    ui:
      addPropertyButton: 'a.gc-add-property-button'
      assignPropertyButton: '.gc-assign-property'
      emptyState: '.gc-constructor-empty-state'

    events:
      'click @ui.addPropertyButton': 'addProperty'
      'click @ui.assignPropertyButton': 'assignProperties'

    handlers:
      'property_constructor:update_listeners_count': @updateListenerCount
      'property_constructor:synced:add': @addSyncedCount
      'workout_exercises:property:added': @hideEmptyState

    childViewOptions: (model) ->
      collection: @visibleProperties

    initialize: (options) ->
      @visibleProperties = new Backbone.Collection(options.visibleProperties)
      @listenerCount = 0
      @syncedExercises = 0
      _.each(@handlers, (func, key) -> App.commands.setHandler(key, func))

    onRender: ->
      if not App.request 'workout_exercises:has_exercise_properties?'
        @ui.emptyState.removeClass 'hidden'

    onDestroy: ->
      _.each(@handlers, (func, key) -> App.commands.removeHandler(key, func))

    addProperty: ->
      # hide empty state p if shown
      @hideEmptyState()
      if App.request 'workout_exercises:has_exercise?'
        @collection.add(new ExerciseProperty, sort: false)
        @ui.assignPropertyButton.removeClass('hidden')
        # notify exercises that a property is being created
        App.vent.trigger 'exercise_property:select:enable'

    onModelRemoved: ->
      if @collection.length is 0
        @ui.assignPropertyButton.addClass('hidden')
        App.vent.trigger 'exercise_property:select:disable'

    assignProperties: (ev) ->
      App.vent.trigger 'exercise_property:assign', @collection.models

    updateListenerCount: (val) =>
      @listenerCount += val

    addSyncedCount: =>
      @syncedExercises += 1
      if @syncedExercises is @listenerCount
        @collection.reset null
        @syncedExercises = 0
        @listenerCount = 0
        @ui.assignPropertyButton.addClass('hidden')
        App.vent.trigger 'exercise_property:select:disable'
        App.request 'messenger:show',
          message: 'Properties Saved'

    hideEmptyState: =>
      if not @ui.emptyState.hasClass('hidden')
        @ui.emptyState.addClass('hidden')
