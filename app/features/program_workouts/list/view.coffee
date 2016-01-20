define [
  './item/view'
  './empty/view'
  'models/program_workout'
], (
  ItemView
  EmptyView
  ProgramWorkout
) ->

  class ProgramWorkoutsListView extends Marionette.CollectionView

    className: 'gc-program-workouts-list'

    childView: ItemView

    getEmptyView: ->
      @options.hasEmptyView && EmptyView

    childEvents:
      'duplicate:program_workout': '_onDuplicate'
      'actions:create': '_onCreate'
      'actions:add': '_quickAddWorkoutToCollection'

    viewComparator: (model) ->
      model.get('position')

    initialize: ->
      @listenTo(@, 'actions:add', @_addWorkoutToCollection)
      @listenTo(@, 'actions:create', @_onCreate)

    _quickAddWorkoutToCollection: (_childView, id) ->
      @trigger('actions:add', id)

    _addWorkoutToCollection: (id) ->
      attrs =
        program_template_id:
          @collection.collection.program_template.get('id')
        workout_template_id: parseInt(id)
        position: @collection.length + 1
        week_id: @options.weekId
      @collection.collection.create(attrs, wait: true)

    _onDuplicate: (childView) ->
      programWorkout = childView.model

      newProgramWorkout = new ProgramWorkout
        program_template_id: programWorkout.get('program_id')
        workout_template_id: programWorkout.get('workout_id')
        position: @collection.length + 1
        week_id: programWorkout.get('week_id')

      newProgramWorkout.save({}, wait: true).then =>
        @collection.add(newProgramWorkout)

    _onCreate: ->
      newProgramWorkout = new ProgramWorkout
        program_template_id: @model.get('id')
        position: @collection.length + 1
        week_id: @options.weekId

      newProgramWorkout.save({}, wait: true).then =>
        @collection.add(newProgramWorkout)
