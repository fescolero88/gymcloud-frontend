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

    childViewOptions: =>
      program_template: @program

    addChild: (child, ChildView, index) ->
      unless child.isInWeek
        Marionette.CollectionView::addChild.apply this, arguments

    ui:
      workoutsList: 'li'

    initialize: (options) ->
      @program = options.program

    onShow: ->
      @addSortable()

    addProgramWorkout: (isInWeek = false) =>
      workout = new WorkoutTemplate
        name: "Workout #{@collection.length + 1}"
        is_visible: false
      workout.save().then =>
        model = new ProgramWorkout
          workout_template_id: workout.id
          program_template_id: @program.id
        model.isInWeek = isInWeek
        model.save().then =>
          @collection.add(model)
          @program.program_workouts.add(model)

    addSortable: ->
      sortableContainers = []
      # TODO: ?
      sortableContainers.push @ui.workoutsList

      dragOptions =
        revertOnSpill: true
        moves: (el, container, handle) ->
          handle.className is 'gc-program-workout-sort'

      Dragula @ui.workoutsList, dragOptions