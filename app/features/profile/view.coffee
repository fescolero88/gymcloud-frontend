define [
  'collections/client_group_members'
  'collections/exercises'
  'collections/workouts'
  'collections/programs'
  './header/view'
  './assignments/view'
  './activity/view'
  'views/trainer/calendar/calendar-view'
  'views/trainer/exercises/exercise-view'
  'models/client_exercise'
  'views/trainer/exercises/personal-best-view'
  'templates/trainer/clients/client'
], (
  ClientGroupMembers
  Exercises
  Workouts
  Programs
  HeaderView
  AssignmentsView
  ActivityView
  CalendarView
  ExerciseView
  ClientExercise
  PersonalBestView
  template
) ->

  class ProfileLayoutView extends Marionette.LayoutView

    template: template

    collectionEvents:
      sync: 'showCenterView'

    regions:
      assignments: '.gc-content-left'
      header: '#client-header-region'
      nav: '#client-content-nav-region'
      leftside: '#client-left-region'
      rightside: '#client-right-region'

    initialize: (data) ->
      @isDroppable = true
      @itemId = data.itemId
      @viewType = data.viewType
      @key = data.key

      @headerView = new HeaderView(model: @model, viewType: @viewType)
      @assignmentsView = new AssignmentsView(model: @model)
      @activityView = new ActivityView
        user: @model
        collection: @model.notifications

      App.vent.on 'drag:complete', @assignDragged

    onDestroy: ->
      App.vent.off 'drag:complete', @assignDragged

    onShow: ->
      @getRegion('assignments').show(@assignmentsView)
      @getRegion('header').show(@headerView)
      @getRegion('rightside').show(@activityView)

    showCenterView: ->
      @leftside.show @centerView

    assignDragged: (item) =>
      # if @centerView.assignName isnt item.get 'category'
        # @loadCenterView item.get 'category'
      @centerView.trigger 'assign', item
      @navView.trigger 'changeActive', item.get 'category'
