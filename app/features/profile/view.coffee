define [
  'backbone.marionette'
  'collections/client_group_members'
  'collections/exercises'
  'collections/workouts'
  'collections/programs'
  './header/view'
  'views/trainer/clients/client-group-nav-view'
  'views/trainer/clients/activity-view'
  'views/trainer/assignments/assignments-view'
  'views/trainer/calendar/calendar-view'
  'views/trainer/groups/members-view'
  'views/trainer/exercises/exercise-view'
  'models/client_exercise'
  'views/trainer/exercises/personal-best-view'
  'templates/trainer/clients/client'
], (
  Marionette
  ClientGroupMembers
  Exercises
  Workouts
  Programs
  HeaderView
  ClientGroupNavView
  ActivityView
  AssignmentsView
  CalendarView
  MembersView
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
      header: '#client-header-region'
      nav: '#client-content-nav-region'
      leftside: '#client-left-region'
      rightside: '#client-right-region'

    initialize: (data) ->
      @isDroppable = true
      @itemId = data.itemId
      if parseInt(@itemId) is 0
        @myProfile = true
      @viewType = data.viewType
      assign = if @viewType is 'clients' then 'exercises' else 'members'
      @assign = data.assign || assign
      @key = data.key
      @recentActivityCollection = data.recentActivity

      @headerView = new HeaderView
        model: App.request('data:profile')
        viewType: @viewType
      @navView = new ClientGroupNavView
        itemId: @itemId
        viewType: @viewType
      @showActivity(false)

      @listenTo @navView, 'navView', @loadCenterView

      App.vent.on 'drag:complete', @assignDragged

      @on 'load:view', @loadView

    onDestroy: =>
      App.vent.off 'drag:complete', @assignDragged

    onShow: ->
      @header.show @headerView
      @nav.show @navView
      @rightside.show @activityView

      @navView.navigate @assign

    showActivity: (isShow) ->
      if !@activityView? or @activityView.isDestroyed
        @activityView = new ActivityView collection: @recentActivityCollection
        if isShow
          @rightside.show @activityView

    loadView: (assign, key) =>
      @key = key
      @assign = assign
      @navView.trigger 'changeActive', assign
      @loadCenterView(assign)

    loadCenterView: (navView) =>
      if @key
        exercise = new ClientExercise
        if @myProfile
          exercise.url = "#{exercise.urlRoot}/me/#{@assign}/#{@key}"
        else
          exercise.url = "#{exercise.urlRoot}/clients/#{@itemId}/#{@assign}/#{@key}"
        exercise.fetch()
        @centerView = new ExerciseView
          model: exercise

        personalBestView = new PersonalBestView
          itemId: @itemId
          assign: @assign
          key: @key
        @rightside.show personalBestView
        @showCenterView()
        @key = null
      else
        link = "#{@viewType}/#{@itemId}"
        if @myProfile
          link = 'me'
        switch navView
          when 'members'
            @collection = new ClientGroupMembers
            @collection.url = "#{@collection.urlRoot}/#{@itemId}/members"
            @collection.fetch()
            @centerView = new MembersView
              groupId: @itemId
              collection: @collection
            @showCenterView()
          when 'exercises'
            @collection = new Exercises
            @collection.url = "/api/mobile/#{link}/exercises"
            @collection.fetch().then =>
              @showCenterView()
            @centerView = new AssignmentsView
              collection: @collection
              clientId: @itemId
              viewType: @viewType
              assignName: navView
          when 'workouts'
            @collection = new Workouts
            @collection.url = "/api/mobile/#{link}/workouts"
            @collection.fetch().then =>
              @showCenterView()
            @centerView = new AssignmentsView
              collection: @collection
              clientId: @itemId
              viewType: @viewType
              assignName: navView
          when 'programs'
            @collection = new Programs
            @collection.url = "/api/mobile/#{link}/programs"
            @collection.fetch().then =>
              @showCenterView()
            @centerView = new AssignmentsView
              collection: @collection
              clientId: @itemId
              viewType: @viewType
              assignName: navView
          when 'calendar'
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
