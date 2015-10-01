define [
  './details/view'
  './privacy/view'
  './weeks/view'
  './weeks/empty/view'
  'collections/program_workouts'
  './workouts/view'
  './template'
  'dragula'
], (
  DetailsView
  PrivacyControlsView
  WeeksView
  WeekEmptyView
  ProgramWorkouts
  WorkoutListView
  template
  Dragula
) ->

  class OverviewView extends Marionette.LayoutView

    template: template

    regions:
      programDetails: '.gc-program-detail-region'
      privacy: '.gc-programs-privacy-region'
      weeks: '.gc-program-weeks-list-region'
      workoutList: 'region[data-name="gc-program-workout-list"]'
      emptyState: 'region[data-name="gc-program-empty-state"]'

    ui:
      workoutList: 'region[data-name="gc-program-workout-list"]'
      weeks: '.gc-program-weeks-list-region'
      emptyState: 'region[data-name="gc-program-empty-state"]'

    initialize: ->
      @collection = @model.program_weeks

      @initDrag()

      @workoutsCollection = @model.program_workouts
      @views = @_prepareViews()

      @listenTo(@views.weeks, 'add:program_workout', @_addProgramWorkout)
      @listenTo(@views.privacy, 'add:program_workout', @_addProgramWorkout)
      @listenTo(@views.privacy, 'add:program_workout:from_library', @_addProgramWorkoutFromLibrary)
      @listenTo(@collection, 'update', @toggleEmptyState)
      @listenTo(@workoutsCollection, 'update', @toggleEmptyState)

    onShow: ->
      for region, view of @views
        @getRegion(region).show(view)
      # emptyStateView = new WeekEmptyView()
      # @getRegion('emptyState').show emptyStateView
      @ui.emptyState.addClass 'hidden'

      @toggleEmptyState()

    toggleEmptyState: ->
      if _.some [
        @collection.isEmpty()
        @workoutsCollection.isEmpty()
      ]
        # @ui.emptyState.removeClass 'hidden'
        # @ui.weeks.addClass 'hidden'
        #@ui.workoutList.addClass 'hidden'
      else
        #@ui.workoutList.removeClass 'hidden'

      if !@workoutsCollection.isEmpty() and @collection.isEmpty()
        @ui.weeks.addClass 'hidden'
        #@ui.workoutList.removeClass 'hidden'
      else
        @ui.weeks.removeClass 'hidden'

    initDrag: ->
      dragOptions =
        revertOnSpill: true
        moves: (el, container, handle) ->
          handle.classList.contains('gc-program-workout-sort')

      @dragula = Dragula [], dragOptions

    _prepareViews: ->
      views = {}
      views.programDetails = new DetailsView
        model: @model
        collection: @collection
        workoutsCollection: @workoutsCollection

      if App.request('current_user_id') is @model.get('author_id')
        views.privacy = new PrivacyControlsView
          model: @model
          collection: @collection
          workoutsCollection: @workoutsCollection

      views.weeks = new WeeksView
        model: @model
        collection: @collection
        sortable: @dragula

      views.workoutList = new WorkoutListView
        program: @model
        collection: @workoutsCollection
        sortable: @dragula

      views

    _addProgramWorkout: ->
      @views.workoutList.addProgramWorkout()

    _addProgramWorkoutFromLibrary: (workoutId) ->
      @views.workoutList.addProgramWorkoutFromLibrary(workoutId)
