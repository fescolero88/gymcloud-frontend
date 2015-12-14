define [
  './item/view'
], (
  ItemView
) ->

  class ExercisePropertiesListView extends Marionette.CollectionView

    tagName: 'ul'

    className: 'workout-exercise-properties'

    childView: ItemView

    initialize: ->
      @default_property = App.request('data:personal_properties:visible')
        .first().attributes
      @listenTo(@, 'properties:init', @initProperty)
      @listenTo(@, 'properties:add', @addProperties)

    initProperty: (options = {}) ->
      @collection.initProperty(
        options.workout_exercise_id,
        @default_property
      )

    addProperties: (options = {}) ->
      @collection.addProperties(
        options.exercise_properties,
        options.workout_exercise_id
      )
