Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

module.exports = class ProgramGlobalPrivacyControlsView extends Marionette.LayoutView

  template: require('templates/trainer/programs/program_global_privacy_controls')

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
    data =
      id: @collection.length + 1
      name: "Week #{@collection.length + 1}"
    @collection.add(data)
    App.request 'messenger:show',
      message: "Program week added."
      type: 'success'

  addProgramWorkout: ->
    App.commands.execute 'program_workout:model:add'

  toggleControlsView: ->
    @ui.defaultControls.toggleClass 'hidden'
    @ui.addWorkoutControls.toggleClass 'hidden'
