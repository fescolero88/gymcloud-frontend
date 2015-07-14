_ = require 'lodash'
Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

class EmptyView extends Marionette.ItemView

  template: require('templates/client/workouts/workout_clientpage_exercises_empty')

class ExercisesItemView extends Marionette.ItemView

  template: require('templates/client/workouts/workout_clientpage_exercise_item')

  tagName: 'li'

module.exports = class WorkoutGlobalExercisesView extends Marionette.CompositeView

  template: require('templates/client/workouts/workout_clientpage_exercises')

  className: 'gc-workouts-exercises-view'

  emptyView: EmptyView

  childView: ExercisesItemView

  childViewContainer: 'ul'

  ui:
    circles: '.gc-workout-exercise-circle'

  initialize: (data) =>
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