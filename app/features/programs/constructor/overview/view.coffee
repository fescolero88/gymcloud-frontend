define [
  'backbone.marionette'
  './details/view'
  './privacy/view'
  './weeks/view'
  './weeks/empty/view'
  'collections/program_weeks'
  'collections/program_workouts'
  './workouts/view'
  './template'
], (
  Marionette
  DetailsView
  PrivacyControlsView
  WeeksView
  WeekEmptyView
  ProgramWeeks
  ProgramWorkouts
  ProgramWorkoutListView
  template
) ->

  class OverviewView extends Marionette.LayoutView

    template: template

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
      @weekWorkoutCollection = new Backbone.Collection
      @workoutsCollection = @model.program_workouts

      @listenTo @collection, 'update', @toggleEmptyState
      @listenTo @workoutsCollection, 'update', @toggleEmptyState

    onShow: ->
      programDetailsView = new DetailsView
        model: @model
        collection: @collection
        workoutsCollection: @workoutsCollection
        weekWorkoutCollection: @weekWorkoutCollection

      @getRegion('programDetails').show programDetailsView

      if App.request('current_user_id') is @model.get('author_id')
        programPrivacyControlsView = new PrivacyControlsView
          model: @model
          collection: @collection
          workoutsCollection: @workoutsCollection

        @getRegion('programPrivacyControls').show programPrivacyControlsView

      programWeeksView = new WeeksView
        model: @model
        collection: @collection
        workoutsCollection: @weekWorkoutCollection

      @getRegion('weeksRegion').show programWeeksView

      programWorkoutListView = new ProgramWorkoutListView
        model: @model
        collection: @workoutsCollection
      @getRegion('programWorkoutListRegion').show programWorkoutListView

      # emptyStateView = new WeekEmptyView()
      # @getRegion('emptyState').show emptyStateView
      @ui.emptyState.addClass 'hidden'

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
      if @collection.length > 0 or
         @workoutsCollection.length > 0 or
         @weekWorkoutCollection > 0
        @ui.programWorkoutListRegion.removeClass 'hidden'
      else
        # @ui.emptyState.removeClass 'hidden'
        # @ui.weeksRegion.addClass 'hidden'
        @ui.programWorkoutListRegion.addClass 'hidden'

      if @workoutsCollection.length > 0 && @collection.length == 0
        @ui.weeksRegion.addClass 'hidden'
      else
        @ui.weeksRegion.removeClass 'hidden'