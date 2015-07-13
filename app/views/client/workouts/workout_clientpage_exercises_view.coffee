_ = require 'lodash'
Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

WorkoutExerciseModel = require 'models/trainer/workout-exercise-model'

class EmptyView extends Marionette.ItemView

  template: require('templates/client/workouts/workout_clientpage_exercises_empty')

class ExercisesItemView extends Marionette.ItemView

  template: require('templates/client/workouts/workout_clientpage_exercise_item')

  tagName: 'li'

  ui:
    orderTag: '.gc-workout-exercise-circle'
    deleteBtn: '.gc-delete-exercise'

  initialize: ->
    @workoutExerciseModel = new WorkoutExerciseModel

module.exports = class WorkoutGlobalExercisesView extends Marionette.CompositeView

  template: require('templates/client/workouts/workout_clientpage_exercises')

  className: 'gc-workouts-exercises-view'

  emptyView: EmptyView

  childView: ExercisesItemView

  childViewOptions: (model) ->
    model.set 'workout_id', @workout.get 'id'
    return model

  childViewContainer: 'ul'

  ui:
    circles: '.gc-workout-exercise-circle'

  templateHelpers: =>
    workout: @workout.attributes

  initialize: (data) =>
    @workout = data.workout
    @on 'render:collection', @showConnectionLines

  showConnectionLines: =>
    circles = @$el.find(".gc-workout-exercise-circle[data-letter]")
    previous = null
    $.each circles, (index, item) =>
        $item = $ item
        letter = $item.data 'letter'

        if letter
          if previous and previous.data 'letter' == letter
            $item.addClass 'last'
            if previous.hasClass 'last'
              previous.removeClass('last').addClass('middle')
            else
              previous.addClass('first')

          previousLetter = letter