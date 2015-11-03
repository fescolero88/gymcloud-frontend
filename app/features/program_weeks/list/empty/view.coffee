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

    behaviors: ->
      auto_complete:
        onItemAdd: @_addProgramWorkoutFromLibrary
        collection: ->
          App.request('current_user').workout_templates.map (item) ->
            id: item.get('id')
            name: item.get('name')
            label: item.get('name')

    events:
      'click @ui.addWorkout': 'toggleViews'
      'click @ui.cancelAddWorkout': 'toggleViews'
      'click @ui.createWorkout': 'createProgramWorkout'

    createProgramWorkout: ->
      @trigger('add:program_workout')
      @toggleViews()

    toggleViews: ->
      @ui.emptyState.toggleClass 'hidden'
      @ui.addWorkoutControls.toggleClass 'hidden'

    _addProgramWorkoutFromLibrary: (workoutId) =>
      @trigger('add:program_workout_from_library', workoutId)
      @toggleViews()
      selectizeInput = @$el.find '.selectize-input'
      selectizeInput.find('div').remove()
