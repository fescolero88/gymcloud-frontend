Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

WorkoutGlobalOverviewView = require 'views/trainer/workouts/workout_global_overview_view'
WorkoutGlobalVideoView = require 'views/trainer/workouts/workout_global_video_view'

WorkoutExerciseModel = require 'models/trainer/workout-exercise-model'

module.exports = class WorkoutGlobalView extends Marionette.LayoutView

  template: Templates.trainer.workouts.workout_global

  regions:
    manageRegion: '#workout-manage'

  ui:
    workoutTitle: '.gc-workout-title span'
    innerNavItems: '.gc-inner-nav li'
    innerNavLinks: '.gc-inner-nav li a'
    navBack: '.gc-content-nav-back'
    addToLibraryButton: '.gc-add-to-library-button'

  events:
    'click @ui.navBack': 'navigateBack'
    'click @ui.innerNavLinks': 'changeViewEvent'
    'blur @ui.workoutTitle': 'workoutTitleSave'
    'click @ui.addToLibraryButton': 'showAddToLibrary'

  templateHelpers: =>
    workout: @workoutModel.attributes

  initialize: (data) =>
    @isDroppable = true
    @workoutModel = data.workout

    App.vent.on 'drag:complete', @assignExercise

    @workoutExerciseModel = new WorkoutExerciseModel
    @listenTo(@workoutExerciseModel, 'sync', @onExerciseAdded)

  onDestroy: =>
    App.vent.off 'drag:complete', @assignExercise

  onShow: =>
    @changeView 'description'

  navigateBack: =>
    window.history.back()

  changeViewEvent: (ev) =>
    ev.preventDefault()
    navItem = $(ev.currentTarget).parent()
    if not $(navItem).hasClass 'active'
      @ui.innerNavItems.removeClass 'active'
      $(navItem).addClass 'active'
      navItemView = $(navItem).data 'view'
      @changeView navItemView

  changeView: (navView) =>
    switch navView
      when 'description'
        @overviewView = new WorkoutGlobalOverviewView model: @workoutModel
        @manageRegion.show @overviewView
      when 'video'
        @videoView = new WorkoutGlobalVideoView model: @workoutModel
        @manageRegion.show @videoView

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

  assignExercise: (item) =>
    category = item.get 'category'
    if category == 'exercises'
      data =
        'id': @workoutModel.get 'id'
        'exercise_id': item.get 'id'

      @workoutExerciseModel.url = "#{@workoutExerciseModel.urlRoot}/#{data.id}/workout_exercises"
      @workoutExerciseModel.set data
      @workoutExerciseModel.addExercise = true
      @workoutExerciseModel.save()

  onExerciseAdded: () =>
    @workoutModel.fetch()
