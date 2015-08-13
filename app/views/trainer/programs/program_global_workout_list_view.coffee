Marionette = require 'backbone.marionette'
ProgramGlobalWorkoutItemView = require 'views/trainer/programs/program_global_workout_item_view'
ProgramWorkoutModel = require 'models/trainer/program-workout-model'

module.exports = class ProgramGlobalWorkoutListView extends Marionette.CompositeView

  template: require 'templates/trainer/programs/program_global_workout_list'

  childViewContainer: '.gc-program-workouts-list'

  childView: ProgramGlobalWorkoutItemView

  initialize: ->
    App.commands.setHandler 'program_workout:model:add', @addProgramWorkout

  onDestroy: ->
    App.commands.removeHandler 'program_workout:model:add', @addProgramWorkout

  addProgramWorkout: =>
    model = new ProgramWorkoutModel()
    @collection.add model
