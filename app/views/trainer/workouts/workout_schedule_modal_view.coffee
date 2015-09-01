define [
  'backbone.marionette'
  'templates/trainer/workouts/workout_schedule_modal'
], (
  Marionette
  workoutScheduleTpl
) ->

  class WorkoutScheduleModal extends Marionette.ItemView
    
    template: workoutScheduleTpl

    ui:
      hasEndDate: '.gc-has-end-date'
      workoutEndDateWrapper: '.gc-workout-end-date-wrapper'

    bindings:
      '.gc-workout-id': 'workoutId'
      '[name="gc-workout-repeat"]': 'repeat'
      '.gc-start-date': 'startDate'
      '.gc-end-date': 'endDate'

    events:
      'change @ui.hasEndDate': 'toggleEndDate'

    onRender: ->
      @stickit()

    toggleEndDate: ->
      @ui.workoutEndDateWrapper.toggleClass 'hidden'
