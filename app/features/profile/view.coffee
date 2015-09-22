define [
  'collections/client_group_members'
  'collections/exercises'
  'collections/workouts'
  'collections/programs'
  './header/view'
  './assignments/view'
  './activity/view'
  'views/trainer/calendar/calendar-view'
  'views/trainer/groups/members-view'
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
      assignments: '.gc-content-left'
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

      @headerView = new HeaderView
        model: @model
        viewType: @viewType
      @assignmentsView = new AssignmentsView(model: @model)
      # @navView = new ClientGroupNavView
      #   itemId: @itemId
      #   viewType: @viewType
      @activityView = new ActivityView
        collection: @model.notifications

      # @listenTo @navView, 'navView', @loadCenterView

      App.vent.on 'drag:complete', @assignDragged

      @on 'load:view', @loadView

    onDestroy: =>
      App.vent.off 'drag:complete', @assignDragged

    onShow: ->
      @getRegion('assignments').show(@assignmentsView)
      @getRegion('header').show(@headerView)
      # @getRegion('nav').show(@navView)
      @getRegion('rightside').show(@activityView)

      # @navView.navigate @assign

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
            # @collection.url = "#{@collection.urlRoot}/#{@itemId}/members"
            # @collection.fetch()
            # @centerView = new MembersView
            #   groupId: @itemId
            #   collection: @collection
            # @showCenterView()
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
      @leftside.show @centerView

    assignDragged: (item) =>
      if @centerView.assignName isnt item.get 'category'
        @loadCenterView item.get 'category'
      @centerView.trigger 'assign', item
      @navView.trigger 'changeActive', item.get 'category'
