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
    hasNote: !!@model.get 'notes'
    hasDescription: !!@model.get 'description'

  initialize: (data) ->
    @collection = new WorkoutExercisesCollection
    @collection.set @model.get('exercises')

    @exercisesView = new WorkoutGlobalExercisesView
      collection: @collection,
      model: @model

    App.vent.on 'workout:notes:add', @showAddNote, @

  onShow: ->
    @exercisesListRegion.show @exercisesView

  onDestroy: ->
    App.vent.off 'workout:notes:add', @showAddNote