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

    emptyView: EmptyView

    childEvents:
      'duplicate:program_workout': '_onDuplicate'

    viewComparator: (model) ->
      model.get('position')

    initialize: ->
      @listenTo(@, 'actions:add', @_addWorkoutToCollection)
      @listenTo(@, 'actions:create', @_redirectToWorkouts)

    _addWorkoutToCollection: (id) ->
      model = @collection.add
        program_template_id:
          @collection.collection.program_template.get('id')
        workout_template_id: parseInt(id)
        position: @collection.length + 1
      model.save()

    _redirectToWorkouts: ->
      # @collection.add({})
      App.vent.trigger 'redirect:to', '#/workout_templates',
        replace: false

    _onDuplicate: (childView) ->
      programWorkout = childView.model

      newProgramWorkout = new ProgramWorkout
        program_template_id: programWorkout.get('program_id')
        workout_template_id: programWorkout.get('workout_id')
        position: @collection.length + 1
        week_id: programWorkout.get('week_id')

      newProgramWorkout.save({}, wait: true).then =>
        @collection.add(newProgramWorkout)
