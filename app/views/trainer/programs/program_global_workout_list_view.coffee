Marionette = require 'backbone.marionette'
ProgramGlobalWorkoutItemView = require 'views/trainer/programs/program_global_workout_item_view'
ProgramWorkoutModel = require 'models/trainer/program-workout-model'

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
    @addSortable()

  addSortable: ->
    @workoutList = @$el.find '.gc-program-workouts-list'
    @workoutList.sortable
      handle: '.gc-workout-header'
      onDrop: @onSortWorkout
      onDragStart: @onDragStart

  onDragStart: ($item, container, _super) =>
    console.log 'test drag: ', container.options.drop, $item
    if not container.options.drop
      $item.clone().insertAfter($item)
    _super $item, container

  onSortWorkout: ($item, container, _super) =>
    console.log 'test sort'
    _super $item, container