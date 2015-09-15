WorkoutGlobalOverviewView = require 'views/trainer/workouts/workout_global_overview_view'
WorkoutGlobalVideoView = require 'views/trainer/workouts/workout_global_video_view'
WorkoutGlobalAssignView = require 'views/trainer/workouts/workout_global_assign_view'

WorkoutExercise = require 'models/workout_exercise'

module.exports = class WorkoutGlobalView extends Marionette.LayoutView

  template: require('templates/trainer/workouts/workout_global')

  regions:
    manageRegion: '#workout-manage'

  ui:
    workoutTitle: '.gc-workout-title span'
    innerNav: '.gc-inner-nav'
    innerNavItems: '.gc-inner-nav li'
    innerNavLinks: '.gc-inner-nav li a'
    contentNavItems: '.gc-content-nav li'
    contentNavLinks: '.gc-content-nav li a'
    addToLibraryButton: '.gc-add-to-library-button'
    addNoteButton: '.gc-workout-add-note'

  events:
    'click @ui.innerNavLinks': 'changeOverviewActiveTab'
    'blur @ui.workoutTitle': 'workoutTitleSave'
    'click @ui.addToLibraryButton': 'showAddToLibrary'
    'click @ui.contentNavLinks': 'changeActiveTab'
    'click @ui.addNoteButton': 'triggerAddNote'
    'keypress @ui.workoutTitle': 'saveTitleOnEnter'

  templateHelpers: =>
    workout: @workoutModel.attributes

  behaviors:

    navigate_back: true

  initialize: (data) =>
    @isDroppable = true
    @workoutModel = data.workout

    App.vent.on 'drag:complete', @assignExercise
    App.vent.on 'workout:add:exercise', @assignExercise

    @workoutExerciseModel = new WorkoutExercise
    @listenTo(@workoutExerciseModel, 'sync', @onExerciseAdded)

  onDestroy: =>
    App.vent.off 'drag:complete', @assignExercise
    App.vent.off 'workout:add:exercise', @assignExercise

  onShow: =>
    @changeView 'description'

  changeOverviewActiveTab: (ev) ->
    @changeViewEvent(ev, @ui.innerNavItems)

  changeActiveTab: (ev) ->
    @changeViewEvent(ev, @ui.contentNavItems)

  changeViewEvent: (ev, ui) =>
    ev.preventDefault()
    navItem = $(ev.currentTarget).parent()
    if not $(navItem).hasClass 'active'
      ui.removeClass 'active'
      $(navItem).addClass 'active'
      navItemView = $(navItem).data 'view'
      @changeView navItemView

  changeView: (navView) =>
    switch navView
      when 'description', 'program'
        @overviewView = new WorkoutGlobalOverviewView model: @workoutModel
        @manageRegion.show @overviewView
        @ui.innerNav.show()
      when 'video'
        @videoView = new WorkoutGlobalVideoView model: @workoutModel
        @manageRegion.show @videoView
        @ui.innerNav.show()
      when 'assign'
        workoutAssignView = new WorkoutGlobalAssignView
          model: @workoutModel
        @manageRegion.show workoutAssignView
        @ui.innerNav.hide()

  workoutTitleSave: =>
    workoutId = @workoutModel.get 'id'
    @workoutModel.set 'name', @ui.workoutTitle.text()
    if @workoutModel.hasChanged()
      @workoutModel.save().success =>
        App.vent.trigger 'ewp:model:updated', 'workouts', workoutId, @workoutModel.get('name')
        App.request('data:reload', 'workouts', App.request 'data:workouts:root').then =>
          App.request 'messenger:show',
            hideAfter: 5
            message: "Workout's title saved."
            type: 'success'

  showAddToLibrary: (ev) =>
    ev.preventDefault()
    App.request 'base:addToLibraryModal', type: 'workouts', model: @workoutModel

  assignExercise: (item) =>
    if item instanceof Backbone.Model
      item = item.toJSON()

    count = @workoutModel.get('exercises').length

    category = item.category
    if category == 'exercises'
      data =
        'id': @workoutModel.get 'id'
        'exercise_id': item.id
        'label': count+1

      @workoutExerciseModel.url = "#{@workoutExerciseModel.urlRoot}/#{data.id}/workout_exercises"
      @workoutExerciseModel.set data
      @workoutExerciseModel.method = 'create'
      @workoutExerciseModel.save()

  onExerciseAdded: () =>
    App.request 'messenger:show',
      hideAfter: 5
      message: 'Exercise Added.'
      type: 'success'
    @workoutModel.fetch()

  triggerAddNote: ->
    App.vent.trigger 'workout:notes:add'

  saveTitleOnEnter: (ev) ->
    if ev.which in [13, 27]
      ev.preventDefault()
      @ui.workoutTitle.blur()
