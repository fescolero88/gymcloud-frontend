# FIXME: to remove

define [
  './overview/view'
  'features/video/assignment/view'
  'features/assignment_list/view'
  'models/workout_exercise'
  './template'
], (
  OverviewView
  VideoAssignmentView
  AssignView
  WorkoutExercise
  template
) ->
  class WorkoutConstructorView extends Marionette.LayoutView

    template: template

    regions:
      manage: 'region[data-name="workout-manage"]'

    ui:
      addNoteButton: '.gc-workout-add-note'

    events:
      'click @ui.addNoteButton': 'triggerAddNote'

    initialize: (data) =>
      @isDroppable = true
      App.vent.on 'drag:complete', @assignExercise
      App.vent.on 'workout:add:exercise', @assignExercise

      @workoutExerciseModel = new WorkoutExercise
      @listenTo(@workoutExerciseModel, 'sync', @onExerciseAdded)

    onDestroy: ->
      App.vent.off 'drag:complete', @assignExercise
      App.vent.off 'workout:add:exercise', @assignExercise

    assignExercise: (item) =>
      if item instanceof Backbone.Model
        item = item.toJSON()

      if item.category == 'exercises'
        position = item.position || @model.exercises.length + 1
        workout_exercise = new WorkoutExercise
          exercise_id: item.id
          workout_id: @model.id
          order_name: position
          position: position
        workout_exercise.save().then =>
          @model.exercises.add(workout_exercise, at: position - 1)

    onExerciseAdded: =>
      App.request 'messenger:show',
        message: 'Exercise Added.'
        type: 'success'
      @model.fetch()

    triggerAddNote: ->
      App.vent.trigger 'workout:notes:add'
