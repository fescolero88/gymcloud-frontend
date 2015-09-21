define [
  'features/privacy_buttons/view'
  './template'
], (
  PrivacyButtons
  template
) ->
  class PrivacyControlsView extends Marionette.LayoutView

    className: 'row gc-remove-margin'

    template: template

    regions:
      privacyButtons: 'region[data-name="privacy-buttons"]'

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

    behaviors: ->
      auto_complete:
        onItemAdd: =>
          console.log('added') # implement view specific logic
        collection: ->
          App.request('current_user').workout_templates.map (item) ->
            id: item.get('id')
            name: item.get('name')
            label: item.get('name')

    events:
      'click @ui.deleteProgram': 'deleteProgram'
      'click @ui.addWeek': 'addProgramWeek'
      'click @ui.createWorkout': 'addProgramWorkout'
      'click @ui.addWorkout': 'toggleControlsView'
      'click @ui.cancelAddWorkout': 'toggleControlsView'

    initialize: (options) ->
      @privacyButtons = new PrivacyButtons(model: @model)
      @workoutsCollection = options.workoutsCollection
      App.commands.setHandler 'program_workouts:add:toggle', @toggleControlsView
      @listenTo @collection, 'update', @toggleAddWorkoutButton
      @listenTo @workoutsCollection, 'update', @toggleAddWorkoutButton

    onDestroy: ->
      App.commands.removeHandler 'program_workouts:add:toggle', @toggleControlsView

    onRender: ->
      @getRegion('privacyButtons').show(@privacyButtons)
      # @toggleAddWorkoutButton()

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
      @trigger('add:program_workout')

    toggleControlsView: =>
      @ui.defaultControls.toggleClass 'hidden'
      @ui.addWorkoutControls.toggleClass 'hidden'

    toggleAddWorkoutButton: ->
      if @collection.length > 0 or @workoutsCollection.length > 0
        @ui.addWorkout.removeClass 'hidden'
      else
        @ui.addWorkout.addClass 'hidden'
