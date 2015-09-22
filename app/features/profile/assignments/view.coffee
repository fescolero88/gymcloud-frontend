define [
  './navigation/view'
  './entity/view'
  './calendar/view'
  'collections/user_collection'
  'models/personal_workout'
  'models/personal_program'
  './template'
], (
  NavigationView
  Entity
  Calendar
  UserCollection
  PersonalWorkout
  PersonalProgram
  template
) ->
  class AssignmentsView extends Marionette.LayoutView

    template: template

    regions:
      navigation: '#client-content-nav-region'
      content: '#client-left-region'

    contentViews:
      personal_workouts:
        model: PersonalWorkout
        view: Entity
      personal_programs:
        model: PersonalProgram
        view: Entity
      calendar:
        model: Backbone.Model
        view: Calendar

    initialize: ->
      @navigationView = new NavigationView
      @listenTo @navigationView, 'change:tab', @_tabChange
      @collections = {}
      _.each @contentViews, (value, key) =>
        @collections[key] = new UserCollection [],
          user: @model
          model: value.model
          type: key

    onShow: ->
      @getRegion('navigation').show(@navigationView)
      @_tabChange(@navigationView.getActiveTabName())

    _tabChange: (tabName) ->
      collection = @collections[tabName]
      collection.fetch().then =>
        viewType = collection.type
        view = new @contentViews[viewType].view
          model: @model
          collection: collection
          viewType: viewType
        @getRegion('content').show(view)