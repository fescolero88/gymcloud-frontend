define [
  'backbone.marionette'
  './item/view'
  'models/program_workout'
  'dragula'
], (
  Marionette
  ProgramGlobalWorkoutItemView
  ProgramWorkout
  Dragula
) ->
  class WorkoutListView extends Marionette.CollectionView

    tagName: 'ul'

    className: 'gc-program-workouts-list'

    childView: ProgramGlobalWorkoutItemView

    ui:
      workoutsList: 'li'

    initialize: ->
      App.commands.setHandler 'program_workout:model:add', @addProgramWorkout

    onDestroy: ->
      App.commands.removeHandler 'program_workout:model:add', @addProgramWorkout

    addProgramWorkout: =>
      model = new ProgramWorkout
      @collection.add model

    onShow: ->
      @addSortable()

    addSortable: ->
      sortableContainers = []
      # TODO: ?
      sortableContainers.push @ui.workoutsList

      dragOptions =
        revertOnSpill: true
        moves: (el, container, handle) ->
          (handle.className is 'gc-program-workout-sort')

      Dragula sortableContainers, dragOptions
