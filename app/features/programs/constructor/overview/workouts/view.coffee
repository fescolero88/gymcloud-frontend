define [
  './item/view'
  'models/program_workout'
  'dragula'
], (
  ProgramGlobalWorkoutItemView
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
      model = new ProgramWorkout
        name: "Workout #{@collection.length + 1}"
        program_template_id: @model.id
        is_visible: false
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
