define [
  './template'
], (
  template
) ->

  class EmptyView extends Marionette.ItemView

    className: 'gc-program-empty-placeholder text-center'

    template: template

    ui:
      addWorkout: '.gc-add-workout'
      addWeek: '.gc-add-week'
      emptyState: '.gc-program-empty-state'
      addWorkoutControls: '.gc-add-workout-controls'
      createWorkout: '.gc-program-create-workout'
      cancelAddWorkout: '.gc-cancel-add-workout'

    events:
      'click @ui.addWorkout': 'toggleViews'
      'click @ui.cancelAddWorkout': 'toggleViews'
      'click @ui.createWorkout': 'createProgramWorkout'

    createProgramWorkout: ->
      App.commands.execute 'program_workout:model:add'
      @toggleViews()

    toggleViews: ->
      @ui.emptyState.toggleClass 'hidden'
      @ui.addWorkoutControls.toggleClass 'hidden'
