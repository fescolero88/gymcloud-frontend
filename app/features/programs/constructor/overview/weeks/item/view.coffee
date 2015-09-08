define [
  'backbone.marionette'
  '../../workouts/view'
  'models/program_workout'
  './template'
], (
  Marionette
  WorkoutListView
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
      _.extend(this.constructor.prototype, Backbone.Stickit.ViewMixin)
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
      name = "Workout ##{@workoutCollection.length + 1}"
      model = new ProgramWorkout
        name: name
        program_template_id: @program.id
        is_visible: false
      model.save().then =>
        @workoutsCollection.add(model)
        @workoutCollection.add(model)

    removeProgramWeek: ->
      App.vent.trigger 'program:remove:week', @model