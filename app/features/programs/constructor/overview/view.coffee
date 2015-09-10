define [
  './details/view'
  './privacy/view'
  './weeks/view'
  './weeks/empty/view'
  'collections/program_weeks'
  'collections/program_workouts'
  './workouts/view'
  './template'
], (
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
      details = new DetailsView
        model: @model
        collection: @collection
        workoutsCollection: @workoutsCollection
        weekWorkoutCollection: @weekWorkoutCollection

      @getRegion('programDetails').show(details)

      if App.request('current_user_id') is @model.get('author_id')
        privacy = new PrivacyControlsView
          model: @model
          collection: @collection
          workoutsCollection: @workoutsCollection

        @getRegion('programPrivacyControls').show(privacy)

      weeks = new WeeksView
        model: @model
        collection: @collection
        workoutsCollection: @weekWorkoutCollection

      @getRegion('weeksRegion').show(weeks)

      workouts = new ProgramWorkoutListView
        model: @model
        collection: @workoutsCollection
      @getRegion('programWorkoutListRegion').show(workouts)

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
      if _.some [
        @collection.isEmpty()
        @workoutsCollection.isEmpty()
        @weekWorkoutCollection.isEmpty()
      ]
        # @ui.emptyState.removeClass 'hidden'
        # @ui.weeksRegion.addClass 'hidden'
        @ui.programWorkoutListRegion.addClass 'hidden'
      else
        @ui.programWorkoutListRegion.removeClass 'hidden'

      if !@workoutsCollection.isEmpty() and @collection.isEmpty()
        @ui.weeksRegion.addClass 'hidden'
        @ui.programWorkoutListRegion.removeClass 'hidden'
      else
        @ui.weeksRegion.removeClass 'hidden'
