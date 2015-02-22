Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

MembersCollection = require 'models/trainer/members-collection'
ExercisesCollection = require 'models/trainer/exercises-collection'
WorkoutsCollection = require 'models/trainer/workouts-collection'
ProgramsCollection = require 'models/trainer/programs-collection'

ClientGroupHeaderView = require 'views/trainer/clients/client-group-header-view'
ClientGroupNavView = require 'views/trainer/clients/client-group-nav-view'
ActivityView = require 'views/trainer/clients/activity-view'

AssignmentsView = require 'views/trainer/assignments/assignments-view'
CalendarView = require 'views/trainer/calendar/calendar-view'

MembersView = require 'views/trainer/groups/members-view'
ExerciseView = require 'views/trainer/exercises/exercise-view'
ClientExerciseModel = require 'models/trainer/client-exercise'
PersonalBestView = require 'views/trainer/exercises/personal-best-view'

module.exports = class ClientGroupView extends Marionette.LayoutView
  template: Templates.trainer.clients.client

  collectionEvents:
    "sync": "showCenterView"

  regions:
    'header': '#client-header-region'
    'nav': '#client-content-nav-region'
    'leftside': '#client-left-region'
    'rightside': '#client-right-region'

  ui:
    itemsLinks: '.gc-exercises-link-exercises, .gc-exercises-link-workouts, .gc-exercises-link-programs'

  events:
    'click @ui.itemsLinks': 'showExercise'

  initialize: (data) ->
    @isDroppable = true
    @itemId = data.itemId
    @viewType = data.viewType
    assign = if @viewType is 'clients' then 'exercises' else 'members'
    @assign = data.assign || assign
    @key = data.key
    @recentActivityCollection = data.recentActivity

    @headerView = new ClientGroupHeaderView model: data.itemModel, viewType: @viewType
    @navView = new ClientGroupNavView itemId: @itemId, viewType: @viewType
    @showActivity(false)

    @listenTo @navView, 'navView', @loadCenterView

    App.vent.on 'drag:complete', @assignDragged

    if not data.assign
      href = window.location.hash + @assign
      Backbone.history.navigate(href, { trigger:false, replace: true })

  onDestroy: =>
    App.vent.off 'drag:complete', @assignDragged

  onShow: ->
    @header.show @headerView
    @nav.show @navView
    @rightside.show @activityView

    @navView.navigate @assign

  showActivity: (isShow)->
    if !@activityView? or @activityView.isDestroyed
      @activityView = new ActivityView collection: @recentActivityCollection
      if isShow
        @rightside.show @activityView

  loadCenterView: (navView) =>
    if @key
      exercise = new ClientExerciseModel
      exercise.url = "#{exercise.urlRoot}/#{@itemId}/#{@assign}/#{@key}"
      exercise.fetch()
      @centerView = new ExerciseView
        model: exercise
      personalBestView = new PersonalBestView
      @rightside.show personalBestView
      @showCenterView()
      @key = null
    else
      switch navView
        when "members"
          @collection = new MembersCollection
          @collection.url = "#{@collection.urlRoot}/#{@itemId}/members"
          @collection.fetch()
          @centerView = new MembersView
            groupId: @itemId
            collection: @collection
          @showCenterView()
        when "exercises"
          @collection = new ExercisesCollection
          @collection.url = "/api/mobile/#{@viewType}/#{@itemId}/exercises"
          @collection.fetch().then =>
            @showCenterView()
          @centerView = new AssignmentsView
            collection: @collection
            clientId: @itemId
            viewType: @viewType
            assignName: navView
        when "workouts"
          @collection = new WorkoutsCollection
          @collection.url = "/api/mobile/#{@viewType}/#{@itemId}/workouts"
          @collection.fetch().then =>
            @showCenterView()
          @centerView = new AssignmentsView
            collection: @collection
            clientId: @itemId
            viewType: @viewType
            assignName: navView
        when "programs"
          @collection = new ProgramsCollection
          @collection.url = "/api/mobile/#{@viewType}/#{@itemId}/programs"
          @collection.fetch().then =>
            @showCenterView()
          @centerView = new AssignmentsView
            collection: @collection
            clientId: @itemId
            viewType: @viewType
            assignName: navView
        when "calendar"
          @centerView = new CalendarView
          @showCenterView()

  showCenterView: ->
    if !@key
      @showActivity(true)
    @leftside.show @centerView
    @listenTo @centerView, 'activityRefresh', ->
      @activityView.refresh()

  assignDragged: (item) =>
    if @centerView.assignName isnt item.get 'category'
      @loadCenterView item.get 'category'
    @centerView.trigger 'assign', item
    @navView.trigger 'changeActive', item.get 'category'

  showExercise: (ev) ->
    ev.preventDefault()
    @key = $(ev.currentTarget).data 'eid'
    @assign = $(ev.currentTarget).data 'assign'
    href = $(ev.currentTarget).attr 'href'
    Backbone.history.navigate(href, { trigger:false, replace: true })
    @loadCenterView(@assign)
