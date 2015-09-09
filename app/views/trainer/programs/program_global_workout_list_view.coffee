ProgramGlobalWorkoutItemView = require 'views/trainer/programs/program_global_workout_item_view'
ProgramWorkout = require 'models/program_workout'
Dragula = require 'dragula'

module.exports = class ProgramGlobalWorkoutListView extends Marionette.CompositeView

  template: require 'templates/trainer/programs/program_global_workout_list'

  childViewContainer: '.gc-program-workouts-list'

  childView: ProgramGlobalWorkoutItemView

  ui:
    workoutsList: '.gc-program-workouts-list'

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
    sortableContainers.push @ui.workoutsList[0]

    dragOptions =
      revertOnSpill: true
      moves: (el, container, handle) ->
        (handle.className is 'gc-program-workout-sort')

    Dragula sortableContainers, dragOptions
