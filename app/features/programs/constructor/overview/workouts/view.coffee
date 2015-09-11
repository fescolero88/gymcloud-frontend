define [
  './item/view'
  'models/workout_template'
  'models/program_workout'
  'dragula'
], (
  ProgramGlobalWorkoutItemView
  WorkoutTemplate
  ProgramWorkout
  Dragula
) ->
  class WorkoutListView extends Marionette.CollectionView

    tagName: 'ul'

    className: 'gc-program-workouts-list'

    childView: ProgramGlobalWorkoutItemView

    childViewOptions:
      program_template: @model

    ui:
      workoutsList: 'li'

    initialize: ->
      App.commands.setHandler 'program_workout:model:add', @addProgramWorkout

    onDestroy: ->
      App.commands.removeHandler 'program_workout:model:add', @addProgramWorkout

    addProgramWorkout: =>
      workout = new WorkoutTemplate
        name: "Workout #{@collection.length + 1}"
        is_visible: false
      workout.save().then =>
        model = new ProgramWorkout
          workout_template_id: workout.id
          program_template_id: @model.id
        model.save().then =>
          @collection.add(model)

    onShow: ->
      @addSortable()

    addSortable: ->
      sortableContainers = []
      # TODO: ?
      sortableContainers.push @ui.workoutsList

      dragOptions =
        revertOnSpill: true
        moves: (el, container, handle) ->
          handle.className is 'gc-program-workout-sort'

      Dragula @ui.workoutsList, dragOptions
