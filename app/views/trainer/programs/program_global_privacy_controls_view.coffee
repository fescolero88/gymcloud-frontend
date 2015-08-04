Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

module.exports = class ProgramGlobalPrivacyControlsView extends Marionette.LayoutView

  template: require('templates/trainer/programs/program_global_privacy_controls')

  ui:
    privacyButtons: '.privacy-buttons > .btn'
    privacyRadios: '[name="privacy"]'
    deleteProgram: '.gc-program-delete-button'

  events:
    'change @ui.privacyRadios': 'togglePrivacy'
    'click @ui.deleteProgram': 'deleteProgram'

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
        id = @model.get 'id'
        name = @model.get 'name'
        App.request 'data:delete', 'programs', id
        window.history.back()
        App.request 'messenger:show',
          hideAfter: 5
          message: "Program #{name} deleted."
          type: 'success'