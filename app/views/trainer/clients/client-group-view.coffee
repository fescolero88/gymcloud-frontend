Marionette = require 'backbone.marionette'

ExercisesCollection = require 'models/trainer/exercises-collection'
WorkoutsCollection = require 'models/trainer/workouts-collection'
ProgramsCollection = require 'models/trainer/programs-collection'

ClientGroupHeaderView = require 'views/trainer/clients/client-group-header-view'
ClientGroupNavView = require 'views/trainer/clients/client-group-nav-view'
ActivityView = require 'views/trainer/clients/activity-view'

AssignmentsView = require 'views/trainer/assignments/assignments-view'
CalendarView = require 'views/trainer/calendar/calendar-view'

module.exports = class ClientGroupView extends Marionette.LayoutView
  template: Templates.trainer.clients.client

  regions:
    'header': '#client-header-region'
    'nav': '#client-content-nav-region'
    'leftside': '#client-left-region'
    'rightside': '#client-right-region'

  initialize: (data) ->
    @isDroppable = true
    @itemId = data.itemId
    @viewType = data.viewType
    @assign = data.assign || 'exercises'
    @calendarType = data.calendarType

    @headerView = new ClientGroupHeaderView model: data.itemModel, viewType: @viewType
    @navView = new ClientGroupNavView itemId: @itemId, viewType: @viewType
    @activityView = new ActivityView collection: data.recentActivity

    @listenTo @navView, 'navView', @loadCenterView

    App.vent.on 'drag:complete', @assignDragged

  onDestroy: =>
    App.vent.off 'drag:complete', @assgnDragged

  onShow: ->
    @header.show @headerView
    @nav.show @navView
    @rightside.show @activityView

    @navView.navigate @assign

  loadCenterView: (navView)=>
    switch navView
      when "exercises"
        exercisesCollection = new ExercisesCollection
        exercisesCollection.url = "/api/mobile/#{@viewType}/#{@itemId}/client_exercises"
        exercisesCollection.fetch()
        @centerView = new AssignmentsView
          collection: exercisesCollection
          clientId: @itemId
          assignName: navView
      when "workouts"
        workoutsCollection = new WorkoutsCollection
        workoutsCollection.url = "/api/mobile/#{@viewType}/#{@itemId}/client_workouts"
        workoutsCollection.fetch()
        @centerView = new AssignmentsView
          collection: workoutsCollection
          clientId: @itemId
          assignName: navView
      when "programs"
        programsCollection = new ProgramsCollection
        programsCollection.url = "/api/mobile/#{@viewType}/#{@itemId}/client_programs"
        programsCollection.fetch()
        @centerView = new AssignmentsView
          collection: programsCollection
          clientId: @itemId
          assignName: navView
      when "calendar"
        @centerView = new CalendarView
    @leftside.show @centerView

  assignDragged: (item) =>
    @centerView.trigger 'assign', item
    if @centerView.assignName != item.get 'category'
      @loadCenterView item.get 'category'
    @navView.trigger 'changeActive', item.get 'category'
