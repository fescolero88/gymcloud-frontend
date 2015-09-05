define [
  'backbone.marionette'
  '../../workouts/view'
  'models/workout_template'
  './template'
], (
  Marionette
  WorkoutListView
  WorkoutTemplate
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
      'click @ui.removeWeek': 'removeProgramWeek'
      'click @ui.addWorkoutBtn': 'addWorkout'

    bindings:
      '[data-bind="name"]':
        observe: 'name'
        events: ['change']

    initialize: (options) ->
      @workoutsCollection = options.workoutsCollection

    onRender: ->
      @stickit()
      @workoutCollection = new Backbone.Collection
      workoutList = new WorkoutListView(collection: @workoutCollection)
      @getRegion('workout').show(workoutList)

    onDestroy: ->
      @unstickit()

    addWorkout: (ev) ->
      ev.preventDefault()
      name = "Workout ##{@workoutCollection.length}"
      model = new WorkoutTemplate(name: name)
      @workoutsCollection.add(model)
      @workoutCollection.add(model)

    removeProgramWeek: ->
      App.vent.trigger 'program:remove:week', @model