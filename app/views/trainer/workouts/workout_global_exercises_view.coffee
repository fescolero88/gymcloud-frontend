_ = require 'lodash'
Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

class EmptyView extends Marionette.ItemView

  template: Templates.trainer.workouts.workout_global_exercises_empty

class ExercisesItemView extends Marionette.ItemView

  template: Templates.trainer.workouts.workout_global_exercise_item

  tagName: 'li'

module.exports = class WorkoutGlobalExercisesView extends Marionette.CompositeView

  template: Templates.trainer.workouts.workout_global_exercises

  className: 'gc-workouts-exercises-view'

  emptyView: EmptyView

  childView: ExercisesItemView

  childViewContainer: 'ul'

  ui:
    circles: '.gc-workout-exercise-circle'

  templateHelpers: =>
    workout: @workout.attributes

  initialize: (data) =>
    @workout = data.workout
    @on 'render:collection', @showConnectionLines

  showConnectionLines: =>
    console.debug
    ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'].every (letter) =>
      console.debug letter
      circles = @$el.find(".gc-workout-exercise-circle[data-letter=#{letter}]")
      if not circles.length
        return false
      circles.addClass('middle')
      circles.eq(0).removeClass('middle').addClass('first')
      circles.eq(circles.length - 1).removeClass('middle').addClass('last')
