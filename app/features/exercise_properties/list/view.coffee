define [
  './item/readable/view'
  './item/editable/view'
], (
  ItemReadableView
  ItemEditableView
) ->

  class ExercisePropertiesListView extends Marionette.CollectionView

    tagName: 'ul'

    className: 'workout-exercise-properties'

    getChildView: (model) =>
      if @editableStateId is model.id
        ItemEditableView
      else
        ItemReadableView

    childEvents:
      'switchTo:editable': '_switchToEditable'
      'switchTo:readable': '_switchToReadable'

    initialize: ->
      @editableStateId = null
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

    _switchToEditable: (childView) ->
      @editableStateId = childView.model.id
      @render()

    _switchToReadable: (childView) ->
      @editableStateId = null
      @render()