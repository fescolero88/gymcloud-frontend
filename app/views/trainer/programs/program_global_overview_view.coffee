Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ProgramGlobalDetailsView = require 'views/trainer/programs/program_global_details_view'
ProgramGlobalPrivacyControlsView = require 'views/trainer/programs/program_global_privacy_controls_view'
ProgramWeeksView = require 'views/trainer/programs/program_weeks_view'
ProgramWeeks = require 'collections/program_weeks'
ProgramWorkouts = require 'collections/program_workouts'
ProgramWorkoutListView = require 'views/trainer/programs/program_global_workout_list_view'

class WeekEmptyView extends Marionette.ItemView
  template: require('templates/trainer/programs/program_week_empty')

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

module.exports = class ProgramGlobalOverviewView extends Marionette.LayoutView

  template: require('templates/trainer/programs/program_global_overview')

  regions:
    programDetails: '.gc-program-detail-region'
    programPrivacyControls: '.gc-programs-privacy-region'
    weeksRegion: '.gc-program-weeks-list-region'
    programWorkoutListRegion: 'region[data-name="gc-program-workout-list"]'
    emptyState: 'region[data-name="gc-program-empty-state"]'

  ui:
    programWorkoutListRegion: 'region[data-name="gc-program-workout-list"]'
    weeksRegion: '.gc-program-weeks-list-region'
    emptyState: 'region[data-name="gc-program-empty-state"]'

  modelEvents:
    sync: 'modelSaved'
    'change:is_public': 'privacyChanged'

  initialize: ->
    @collection = new ProgramWeeks
    @workoutsCollection = new ProgramWorkouts

    @listenTo @collection, 'update', @toggleEmptyState
    @listenTo @workoutsCollection, 'update', @toggleEmptyState

  onShow: ->
    programDetailsView = new ProgramGlobalDetailsView
      model: @model
      collection: @collection
      workoutsCollection: @workoutsCollection

    @getRegion('programDetails').show programDetailsView

    programPrivacyControlsView = new ProgramGlobalPrivacyControlsView
      model: @model
      collection: @collection
      workoutsCollection: @workoutsCollection

    @getRegion('programPrivacyControls').show programPrivacyControlsView
    
    programWeeksView = new ProgramWeeksView model: @model, collection: @collection
    @getRegion('weeksRegion').show programWeeksView

    programWorkoutListView = new ProgramWorkoutListView collection: @workoutsCollection
    @getRegion('programWorkoutListRegion').show programWorkoutListView

    emptyStateView = new WeekEmptyView()
    @getRegion('emptyState').show emptyStateView

    @toggleEmptyState()

  privacyChanged: ->
    @isPrivacyChanged = true

  modelSaved: ->
    if @isPrivacyChanged
      @isPrivacyChanged = false
      App.request 'messenger:show',
        message: "Privacy Settings changed."
        type: 'info'
    else
      App.request 'messenger:show',
        message: "Program Updated Successfully"
        type: 'success'

  toggleEmptyState: ->
    if @collection.length > 0 or @workoutsCollection.length > 0
      @ui.emptyState.addClass 'hidden'
      @ui.weeksRegion.removeClass 'hidden'
      @ui.programWorkoutListRegion.removeClass 'hidden'
    else
      @ui.emptyState.removeClass 'hidden'
      @ui.weeksRegion.addClass 'hidden'
      @ui.programWorkoutListRegion.addClass 'hidden'
