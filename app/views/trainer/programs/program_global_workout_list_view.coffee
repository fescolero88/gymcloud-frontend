Marionette = require 'backbone.marionette'
ProgramGlobalWorkoutItemView = require 'views/trainer/programs/program_global_workout_item_view'
ProgramWorkoutModel = require 'models/trainer/program-workout-model'
Dragula = require 'dragula'

module.exports = class ProgramGlobalWorkoutListView extends Marionette.CompositeView

  template: require 'templates/trainer/programs/program_global_workout_list'

  childViewContainer: '.gc-program-workouts-list'

  childView: ProgramGlobalWorkoutItemView

  ui:
    workoutList: '.gc-program-workouts-list'

  initialize: ->
    App.commands.setHandler 'program_workout:model:add', @addProgramWorkout
    @listenTo @collection, 'add', @workoutAdded

  onDestroy: ->
    App.commands.removeHandler 'program_workout:model:add', @addProgramWorkout

  addProgramWorkout: =>
    model = new ProgramWorkoutModel()
    @collection.add model

  workoutAdded: ->
    @addSortable() if @collection.length is 1


  addSortable: ->
    sortableContainers = []
    sortableContainers.push @el.querySelector 'ul.gc-program-workouts-list'

    dragOptions =
      revertOnSpill: true
      moves: (el, container, handle) =>
        return (handle.className is 'gc-program-workout-sort')

    Dragula sortableContainers, dragOptions