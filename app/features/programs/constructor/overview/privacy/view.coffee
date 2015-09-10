define [
  './template'
], (
  template
) ->
  class PrivacyControlsView extends Marionette.LayoutView

    className: 'row gc-remove-margin'

    template: template

    ui:
      privacyButtons: '.privacy-buttons > .btn'
      privacyRadios: '[name="privacy"]'
      deleteProgram: '.gc-program-delete-button'
      addWeek: '.gc-program-add-week'
      createWorkout: '.gc-program-create-workout'
      addWorkout: '.gc-program-add-workout'
      addWorkoutControls: '.gc-add-workout-controls'
      defaultControls: '.gc-default-controls'
      cancelAddWorkout: '.gc-cancel-add-workout'

    events:
      'change @ui.privacyRadios': 'togglePrivacy'
      'click @ui.deleteProgram': 'deleteProgram'
      'click @ui.addWeek': 'addProgramWeek'
      'click @ui.createWorkout': 'addProgramWorkout'
      'click @ui.addWorkout': 'toggleControlsView'
      'click @ui.cancelAddWorkout': 'toggleControlsView'

    initialize: (options) ->
      @workoutsCollection = options.workoutsCollection
      App.commands.setHandler 'program_workouts:add:toggle', @toggleControlsView
      @listenTo @collection, 'update', @toggleAddWorkoutButton
      @listenTo @workoutsCollection, 'update', @toggleAddWorkoutButton

    onDestroy: ->
      App.commands.removeHandler 'program_workouts:add:toggle', @toggleControlsView

    onRender: ->
      # @toggleAddWorkoutButton()

    togglePrivacy: (ev) ->
      @ui.privacyButtons.removeClass 'active'
      $(ev.currentTarget).parent().addClass 'active'
      isPublic = ev.currentTarget.value == 'true'
      @model.set 'is_public', isPublic
      @model.save()

    deleteProgram: ->
      App.request 'base:confirmationalModal',
        title: "Remove program?"
        content: "Are you sure you want to delete this program?"
        confirmBtn: "Remove"
        confirmCallBack: =>
          @model.destroy()

    addProgramWeek: ->
      @collection.add(name: "Week #{@collection.length + 1}")
      App.request 'messenger:show',
        message: "Program week added."
        type: 'success'

    addProgramWorkout: ->
      App.commands.execute 'program_workout:model:add'

    toggleControlsView: =>
      @ui.defaultControls.toggleClass 'hidden'
      @ui.addWorkoutControls.toggleClass 'hidden'

    toggleAddWorkoutButton: ->
      if @collection.length > 0 or @workoutsCollection.length > 0
        @ui.addWorkout.removeClass 'hidden'
      else
        @ui.addWorkout.addClass 'hidden'
