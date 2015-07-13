Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

WorkoutGlobalOverviewView = require 'views/client/workouts/workout_clientpage_overview_view'
WorkoutGlobalVideoView = require 'views/trainer/workouts/workout_global_video_view'

WorkoutExerciseModel = require 'models/trainer/workout-exercise-model'

module.exports = class WorkoutGlobalView extends Marionette.LayoutView

  template: require('templates/client/workouts/workout_clientpage')

  regions:
    manageRegion: '#workout-manage'

  ui:
    workoutTitle: '.gc-workout-title span'
    innerNav: '.gc-inner-nav'
    innerNavItems: '.gc-inner-nav li'
    innerNavLinks: '.gc-inner-nav li a'
    contentNavItems: '.gc-content-nav li'
    contentNavLinks: '.gc-content-nav li a'
    navBack: '.gc-content-nav-back'
    addToLibraryButton: '.gc-add-to-library-button'
    addNoteButton: '.gc-workout-add-note'

  events:
    'click @ui.navBack': 'navigateBack'
    'click @ui.innerNavLinks': 'changeOverviewActiveTab'
    'click @ui.addToLibraryButton': 'showAddToLibrary'
    'click @ui.contentNavLinks': 'changeActiveTab'

  templateHelpers: =>
    workout: @workoutModel.attributes

  initialize: (data) =>
    @workoutModel = data.workout

    @workoutExerciseModel = new WorkoutExerciseModel
    @listenTo(@workoutExerciseModel, 'sync', @onExerciseAdded)

  onDestroy: =>
    App.vent.off 'drag:complete', @assignExercise
    App.vent.off 'workout:add:exercise', @assignExercise

  onShow: =>
    @changeView 'description'

  navigateBack: =>
    window.history.back()

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

  showAddToLibrary: (ev) =>
    ev.preventDefault()
    App.request 'base:addToLibraryModal', type: 'workouts', model: @workoutModel