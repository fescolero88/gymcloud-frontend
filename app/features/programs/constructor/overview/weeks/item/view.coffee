define [
  './workouts'
  'models/workout_template'
  'models/program_workout'
  './template'
], (
  WorkoutListView
  WorkoutTemplate
  ProgramWorkout
  template
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

    bindings:
      '[data-bind="name"]':
        observe: 'name'
        events: ['change']

    initialize: (options) ->
      collection = new Backbone.Collection
      @workoutList = new WorkoutListView
        collection: collection
        program: options.program

    onRender: ->
      @stickit()
      @getRegion('workout').show(@workoutList)

    onDestroy: ->
      @unstickit()

    addWorkout: (ev) ->
      ev.preventDefault()
      @workoutList.addProgramWorkout(true)

    removeModel: ->
      @model.destroy()
      # TODO: delete workouts inside
      App.request 'messenger:show',
        message: "Program #{model.get('name')} has been removed."
        type: 'info'