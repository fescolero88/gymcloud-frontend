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
      @_switchViewStateFor(childView, 'editable')

    _switchToReadable: (childView) ->
      @_switchViewStateFor(childView, 'readable')

    _switchViewStateFor: (childView, state = 'readable') ->
      if state is 'readable'
        @editableStateId = null
      else
        @editableStateId = childView.model.id
      @collection.remove(childView.model)
      @collection.add(childView.model, at: childView._index)