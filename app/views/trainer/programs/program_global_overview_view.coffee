Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ProgramGlobalDetailsView = require 'views/trainer/programs/program_global_details_view'
ProgramGlobalPrivacyControlsView = require 'views/trainer/programs/program_global_privacy_controls_view'
ProgramWeeksView = require 'views/trainer/programs/program_weeks_view'
ProgramWeeksCollection = require 'models/trainer/program_weeks_collection'

module.exports = class ProgramGlobalOverviewView extends Marionette.LayoutView

  template: require('templates/trainer/programs/program_global_overview')

  regions:
    programDetails: '.gc-program-detail-region'
    programPrivacyControls: '.gc-programs-privacy-region'
    weeksRegion: '.gc-program-weeks-list-region'

  modelEvents:
    sync: 'modelSaved'
    'change:is_public': 'privacyChanged'

  onShow: ->
    @collection = new ProgramWeeksCollection []
    programDetailsView = new ProgramGlobalDetailsView model: @model, collection: @collection
    @getRegion('programDetails').show programDetailsView
    programPrivacyControlsView = new ProgramGlobalPrivacyControlsView model: @model, collection: @collection
    @getRegion('programPrivacyControls').show programPrivacyControlsView
    programWeeksView = new ProgramWeeksView model: @model, collection: @collection
    @getRegion('weeksRegion').show programWeeksView

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