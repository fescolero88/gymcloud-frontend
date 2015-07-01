Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

WorkoutGlobalExercisesView = require 'views/trainer/workouts/workout_global_exercises_view'
WorkoutExercisesCollection = require 'models/trainer/workout_exercises_collection'

module.exports = class WorkoutGlobalOverviewView extends Marionette.LayoutView

  template: require('templates/trainer/workouts/workout_global_overview')

  className: 'gc-workouts-workout-view'

  regions:
    exercisesListRegion: '#gc-exercises-list-region'

  ui:
    workoutDescription: '.gc-workout-description-editor'
    workoutExerciseAddButton: '.gc-workout-add-exercise-button'
    workoutDeleteButton: '.gc-workout-delete-button'

  events:
    'keyup @ui.workoutDescription': 'workoutDescriptionAutoHeight'
    'click @ui.workoutExerciseAddButton': 'workoutExerciseAdd'
    'click @ui.workoutDeleteButton': 'workoutDelete'
    'blur @ui.workoutDescription': 'workoutDescriptionSave'

  templateHelpers: =>
    workout: @workoutModel.attributes

  initialize: (data) =>
    @workoutModel = data.model
    exercisesCollection = new WorkoutExercisesCollection
    exercisesCollection.set @model.get('exercises')
    @exercisesView = new WorkoutGlobalExercisesView collection: exercisesCollection, workout: @workoutModel

  onShow: =>
    @exercisesListRegion.show @exercisesView
    @workoutDescriptionAutoHeight()

  workoutDescriptionAutoHeight: =>
    workoutDesc = @ui.workoutDescription.get 0
    if workoutDesc.scrollHeight > workoutDesc.clientHeight
      workoutDesc.style.height = "#{workoutDesc.scrollHeight}px"

  workoutExerciseAdd: (e) =>
    e.preventDefault()

  workoutDelete: =>
    workoutId = @model.get 'id'
    workoutName = @model.get 'name'
    App.request 'base:confirmationalModal',
      title: 'Delete workout'
      content: "Are you sure you want to delete #{workoutName}?"
      confirmBtn: 'Delete'
      confirmCallBack: =>
        @model.destroy().success =>
          App.request 'data:delete', 'workouts', workoutId
          window.history.back()
          App.request 'messenger:show',
            hideAfter: 5
            message: "Workout #{workoutName} deleted."
            type: 'success'

  workoutDescriptionSave: =>
    @model.set 'description', @ui.workoutDescription.val()
    if @model.hasChanged()
      @model.save().success =>
        App.request 'messenger:show',
          hideAfter: 5
          message: "Workout's description saved."
          type: 'success'
