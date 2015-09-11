define [
  '../../workouts/view'
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
      'click @ui.removeWeek': 'removeProgramWeek'
      'click @ui.addWorkoutBtn': 'addWorkout'

    bindings:
      '[data-bind="name"]':
        observe: 'name'
        events: ['change']

    initialize: (options) ->
      @program = options.program
      @workoutsCollection = options.workoutsCollection

    onRender: ->
      @stickit()
      @workoutCollection = new Backbone.Collection
      workoutList = new WorkoutListView
        collection: @workoutCollection
        model: @program
      @getRegion('workout').show(workoutList)

    onDestroy: ->
      @unstickit()

    addWorkout: (ev) ->
      ev.preventDefault()
      workout = new WorkoutTemplate
        name: "Workout #{@workoutCollection.length + 1}"
        is_visible: false
      workout.save().then =>
        model = new ProgramWorkout
          workout_template_id: workout.id
          program_template_id: @program.id
        model.save().then =>
          @workoutsCollection.add(model)
          @workoutCollection.add(model)

    removeProgramWeek: ->
      App.vent.trigger 'program:remove:week', @model
