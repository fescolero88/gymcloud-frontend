ClientEWPView = require 'views/client/clientpage-ewp-view'
UserCollection = require 'collections/user_collection'

ExerciseGlobalView = require 'views/client/exercises/exercise_clientpage_view'
WorkoutExercise = require 'models/workout_exercise'
GlobalExercise = require 'models/global_exercise'

WorkoutGlobalView = require 'views/client/workouts/workout-clientpage-view'
GlobalWorkout = require 'models/global_workout'
PersonalWorkout = require 'models/personal_workout'
PersonalProgram = require 'models/personal_program'

CalendarDayView = require 'views/client/clientpage-calendar-day-view'
CalendarWeekView = require 'views/client/clientpage-calendar-week-view'
CalendarMonthView = require 'views/client/clientpage-calendar-month-view'

MessagesView = require 'views/general/messages/messages-view'

module.exports = class ClientPageController extends Marionette.Controller
  queueMethod: false

  queue: =>
    if @queueMethod
      if App.request('auth:isAuthorizedAs', 'client')
        @[@queueMethod].apply(null, @queueArgs)
        @queueMethod = false
        @queueArgs = null

  initialize: (options) =>
    @userPageView = App.request('app:views:main')
    App.vent.on 'assignments:loaded', =>
      @queue()

  workoutExercisesList: ->
    @_assignedEntityList('workout_exercises')

  workoutExercise: (id) ->
    @_assignedEntityShow('workout_exercises', id)

  personalWorkoutList: ->
    @_assignedEntityList('personal_workouts')

  personalWorkout: (id) ->
    @_assignedEntityShow('personal_workouts', id)

  personalProgramList: ->
    @_assignedEntityList('personal_programs')

  _assignedEntityList: (type) ->
    dataType = type.split('_')[1]
    @changeNavTitle(dataType)
    eventName = 'clientpage:nav-click'
    elementId = "#gc-clientpage-nav-tab-#{dataType}"
    App.vent.trigger(eventName, elementId)
    view = new ClientEWPView
      collection: new UserCollection([], type: type)
      dataType: dataType
      type: type
    @userPageView.content.show(view)

  _assignedEntityShow: (type, id) ->
    dataType = type.split('_')[1]
    eventName = 'clientpage:nav-click'
    elementId = "#gc-clientpage-nav-tab-#{dataType}"
    App.vent.trigger(eventName, elementId)

    klasses = {
      workout_exercises:
        model: WorkoutExercise
        view: ExerciseGlobalView
      personal_workouts:
        model: PersonalWorkout
        view: WorkoutGlobalView
      personal_programs:
        model: PersonalProgram
        view: WorkoutGlobalView
    }[type]

    model = new klasses.model(id: id)
    model.fetch().then =>
      view = new klasses.view
        model: model
        breadcrumbs: [{title: dataType}]
      @userPageView.content.show(view)

  clientPageAssigments: (dataType, key) =>
    dataType = dataType || 'exercises'
    App.vent.trigger 'clientpage:nav-click', "#gc-clientpage-nav-tab-#{dataType}"

    items = App.request("data:#{dataType}")
    if items?
      breadcrumbs = [{title:"#{dataType}"}]
      if key
        searchResults = @searchInLibrary(new Backbone.Collection(items), key, breadcrumbs)
        childModel = searchResults.model
        #items = childModel.get('items')
      else
        childModel = new Backbone.Model

      if (childModel and childModel.get('isFolder')) or not key
        exercisesGlobalView = new ClientEWPView(collection: new Backbone.Collection(items), dataType: dataType)
        @userPageView.content.show exercisesGlobalView
      else
        klasses = {
          exercises:
            model: GlobalExercise,
            view: ExerciseGlobalView
          workouts:
            model: GlobalWorkout,
            view: WorkoutGlobalView
        }[dataType]

        model = new klasses.model
        model.url = model.urlRoot + key
        model.fetch().then =>
          view = new klasses.view
            model: model
            breadcrumbs: breadcrumbs
          @userPageView.content.show view
    else
      @queueMethod = 'clientPageAssigments'
      @queueArgs = arguments

  searchInLibrary: (items, key, breadcrumbs) =>
    filtered = items.where({key: parseInt(key)})
    if filtered.length
      result = filtered[0]
      breadcrumbs.push({title: result.get('title')})
    else
      items.each (item) =>
        if item.has('items')
          searchResults = @searchInLibrary(new Backbone.Collection(item.get('items')), key, [{title: item.get 'title'}])
          if searchResults.model
            result = searchResults.model
            breadcrumbs = breadcrumbs.concat searchResults.path
    return {model: result, path: breadcrumbs}

  clientPageCalendarDay: (id) =>
    contentView = new CalendarDayView()
    @userPageView.content.show contentView
    @changeNavTitle 'Calendar'
    App.vent.trigger 'clientpage:nav-click', '#gc-clientpage-nav-tab-c'

  clientPageCalendarWeek: (id) =>
    contentView = new CalendarWeekView()
    @userPageView.content.show contentView
    @changeNavTitle 'Calendar'
    App.vent.trigger 'clientpage:nav-click', '#gc-clientpage-nav-tab-c'

  clientPageCalendarMonth: (id) =>
    contentView = new CalendarMonthView()
    @userPageView.content.show contentView
    @changeNavTitle 'Calendar'
    App.vent.trigger 'clientpage:nav-click', '#gc-clientpage-nav-tab-c'

  changeNavTitle: (type) ->
    App.vent.trigger 'client:nav:change', type
