define [
  './workouts'
  'models/workout_template'
  'models/program_workout'
  './template'
  'collections/program_workouts'
], (
  WorkoutListView
  WorkoutTemplate
  ProgramWorkout
  template
  ProgramWorkouts
) ->
  class WeekItemView extends Marionette.LayoutView

    template: template

    className: 'gc-program-week-item'

    ui:
      removeWeek: '.gc-remove-program-week'
      addWorkoutBtn: '.gc-week-workouts-empty button'

    regions:
      workout: '.gc-program-weeks-workouts-container'

    events:
      'click @ui.removeWeek': 'removeModel'
      'click @ui.addWorkoutBtn': 'addWorkout'

    behaviors:
      stickit:
        bindings:
          '[data-bind="name"]':
            observe: 'name'
            events: ['change']

    modelEvents:
      'remove': 'weekRemoved'

    initialize: (options) ->
      collection = new ProgramWorkouts @model.get('program_workouts')
      @workoutList = new WorkoutListView
        collection: collection
        program: options.program
        sortable: options.sortable
        weekId: @model.get 'id'

    onRender: ->
      @getRegion('workout').show(@workoutList)

    addWorkout: (ev) ->
      @workoutList.addProgramWorkout(true)

    removeModel: ->
      App.request 'base:confirmationalModal',
        title: "Remove program week?"
        content: "Are you sure you want to delete this week?"
        confirmBtn: "Remove"
        confirmCallBack: =>
          @model.destroy(wait: true)

    weekRemoved: ->
      App.request 'messenger:show',
        message: "Week #{@model.get('name')} has been removed."
        type: 'info'

    _assignWeekPosition: ->
      pos = @$el.index() + 1
      @model.setPosition(pos)
