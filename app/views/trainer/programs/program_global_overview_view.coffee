Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ProgramGlobalDetailsView = require 'views/trainer/programs/program_global_details_view'
ProgramGlobalPrivacyControlsView = require 'views/trainer/programs/program_global_privacy_controls_view'

module.exports = class ProgramGlobalOverviewView extends Marionette.LayoutView

  template: require('templates/trainer/programs/program_global_overview')

  regions:
    programDetails: '.gc-program-detail-region'
    programPrivacyControls: '.gc-programs-privacy-region'

  modelEvents:
    sync: 'modelSaved'
    'change:is_public': 'privacyChanged'

  onShow: ->
    programDetailsView = new ProgramGlobalDetailsView model: @model
    @getRegion('programDetails').show programDetailsView
    programPrivacyControlsView = new ProgramGlobalPrivacyControlsView model: @model
    @getRegion('programPrivacyControls').show programPrivacyControlsView

  privacyChanged: ->
   @privacyChanged = true

  modelSaved: ->
    if @privacyChanged
      @privacyChanged = false
      App.request 'messenger:show',
        message: "Privacy Settings changed."
        type: 'info'
    else
      App.request 'messenger:show',
        message: "Program Updated Successfully"
        type: 'success'