Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

WorkoutGlobalExercisesView = require 'views/client/workouts/workout_clientpage_exercises_view'
WorkoutExercisesCollection = require 'models/trainer/workout_exercises_collection'

module.exports = class WorkoutGlobalOverviewView extends Marionette.LayoutView

  template: require('templates/client/workouts/workout_clientpage_overview.hbs')

  className: 'gc-workouts-workout-view'

  regions:
    exercisesListRegion: '#gc-exercises-list-region'

  templateHelpers: =>
    workout: @model.attributes
    hasNote: !!@model.get 'notes'
    hasDescription: !!@model.get 'description'

  initialize: (data) ->
    @exercisesCollection = new WorkoutExercisesCollection
    @exercisesCollection.set @model.get('exercises')

    @exercisesView = new WorkoutGlobalExercisesView
      collection: @exercisesCollection,
      workout: @model

    App.vent.on 'workout:notes:add', @showAddNote, @

  onShow: ->
    @exercisesListRegion.show @exercisesView

  onDestroy: ->
    App.vent.off 'workout:notes:add', @showAddNote