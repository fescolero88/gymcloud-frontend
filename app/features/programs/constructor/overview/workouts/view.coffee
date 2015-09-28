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

    viewComparator: (model) ->
      model.get 'position'

    initialize: (options) ->
      @program = options.program

    onShow: ->
      @addSortable()

    addProgramWorkout: (isInWeek = false) =>
      workout = new WorkoutTemplate
        name: "Workout #{@collection.length + 1}"
        is_visible: false
        position: @collection.length + 1
      workout.save().then =>
        model = new ProgramWorkout
          workout_template_id: workout.id
          program_template_id: @program.id
        model.isInWeek = isInWeek
        model.save().then =>
          @collection.add(model)
          @program.program_workouts.add(model)

    addProgramWorkoutFromLibrary: (workoutId, isInWeek = false) ->
      model = new ProgramWorkout
        workout_template_id: workoutId
        program_template_id: @program.id
        position: @collection.length + 1

      model.isInWeek = isInWeek
      model.save().then =>
        @collection.add(model)
        @program.program_workouts.add(model)


    addSortable: ->
      dragOptions =
        revertOnSpill: true
        moves: (el, container, handle) ->
          handle.classList.contains('gc-program-workout-sort')

      Dragula [@el], dragOptions
        .on 'drop', (el, container) =>
          @.children.call '_positionChanged'