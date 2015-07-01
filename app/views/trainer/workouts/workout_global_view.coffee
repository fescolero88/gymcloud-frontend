Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

WorkoutGlobalOverviewView = require 'views/trainer/workouts/workout_global_overview_view'
WorkoutGlobalVideoView = require 'views/trainer/workouts/workout_global_video_view'
WorkoutGlobalAssignView = require 'views/trainer/workouts/workout_global_assign_view'

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
    navBack: '.gc-content-nav-back'
    addToLibraryButton: '.gc-add-to-library-button'

  events:
    'click @ui.navBack': 'navigateBack'
    'click @ui.innerNavLinks': 'changeOverviewActiveTab'
    'blur @ui.workoutTitle': 'workoutTitleSave'
    'click @ui.addToLibraryButton': 'showAddToLibrary'
    'click @ui.contentNavLinks': 'changeActiveTab'

  templateHelpers: =>
    workout: @workoutModel.attributes

  initialize: (data) =>
    @workoutModel = data.workout

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
      when 'assign'
        workoutAssignView = new WorkoutGlobalAssignView
          model: @workoutModel
        @manageRegion.show workoutAssignView
        @ui.innerNav.hide()

  workoutTitleSave: =>
    @workoutModel.set 'name', @ui.workoutTitle.text()
    if @workoutModel.hasChanged()
      @workoutModel.save().success =>
        App.request 'messenger:show',
          hideAfter: 5
          message: "Workout's title saved."
          type: 'success'

  showAddToLibrary: (ev) =>
    ev.preventDefault()
    App.request 'base:addToLibraryModal', type: 'workouts', model: @workoutModel
