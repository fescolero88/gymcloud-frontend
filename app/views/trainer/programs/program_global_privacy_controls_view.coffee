Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

module.exports = class ProgramGlobalPrivacyControlsView extends Marionette.LayoutView

  template: require('templates/trainer/programs/program_global_privacy_controls')

  ui:
    privacyButtons: '.privacy-buttons > .btn'
    privacyRadios: '[name="privacy"]'
    deleteProgram: '.gc-program-delete-button'
    addWeek: '.gc-program-add-week'

  events:
    'change @ui.privacyRadios': 'togglePrivacy'
    'click @ui.deleteProgram': 'deleteProgram'
    'click @ui.addWeek': 'addProgramWeek'

  modelEvents:
    destroy: 'programDeleted'

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

  programDeleted: ->
    id = @model.get 'id'
    name = @model.get 'name'
    App.request 'data:delete', 'programs', id

    rootId = App.request "data:programs:root"
    folderId = @model.get 'folder_id'
    @model.set 'key', @model.get('id')
    if folderId and folderId isnt 0 and folderId isnt rootId
      App.vent.trigger "programs:folder:#{folderId}:model:removed", @model
    else
      App.vent.trigger "programs:model:removed", @model

    window.history.back()
    App.request 'messenger:show',
      hideAfter: 5
      message: "Program #{name} deleted."
      type: 'info'

  addProgramWeek: ->
    data =
      id: @collection.length + 1
      name: "Week #{@collection.length + 1}"
    @collection.add(data)
    App.request 'messenger:show',
      message: "Program week added."
      type: 'success'