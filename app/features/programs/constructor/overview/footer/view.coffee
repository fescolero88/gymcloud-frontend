define [
  'features/privacy_buttons/view'
  './template'
], (
  PrivacyButtons
  template
) ->
  class FooterControlsView extends Marionette.LayoutView

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
        onItemAdd: @_addProgramWorkoutFromLibrary
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
      @listenTo(@collection, 'update', @toggleAddWorkoutButton)
      @listenTo(@workoutsCollection, 'update', @toggleAddWorkoutButton)
      @

    onDestroy: ->
      App.commands.removeHandler 'program_workouts:add:toggle', @toggleControlsView

    onShow: ->
      @toggleAddWorkoutButton()

    onRender: ->
      @getRegion('privacyButtons').show(@privacyButtons) if @_isAuthor()

    deleteProgram: ->
      App.request 'base:confirmationalModal',
        title: "Remove program?"
        content: "Are you sure you want to delete this program?"
        confirmBtn: "Remove"
        confirmCallBack: =>
          @model.destroy()

    addProgramWeek: ->
      App.vent.trigger 'add:program:week'

    addProgramWorkout: ->
      @trigger('add:program_workout')

    _addProgramWorkoutFromLibrary: (workoutId) =>
      @trigger('add:program_workout:from_library', workoutId)
      selectizeInput = @$el.find '.selectize-input'
      selectizeInput.find('div').remove()

    toggleControlsView: =>
      @ui.defaultControls.toggleClass 'hidden'
      @ui.addWorkoutControls.toggleClass 'hidden'

    toggleAddWorkoutButton: ->
      if @collection.length > 0 or @workoutsCollection.length > 0
        @ui.addWorkout.removeClass 'hidden'
        @ui.addWeek.removeClass 'hidden'
      else
        @ui.addWorkout.addClass 'hidden'
        @ui.addWeek.addClass 'hidden'

    _isAuthor: =>
      @model.get('author_id') is App.request('current_user_id')