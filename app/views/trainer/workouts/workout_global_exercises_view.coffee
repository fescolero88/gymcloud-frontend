_ = require 'lodash'
Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

WorkoutExerciseModel = require 'models/trainer/workout-exercise-model'

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
    ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'].every (letter) =>
      circles = @$el.find(".gc-workout-exercise-circle[data-letter=#{letter}]")
      if not circles.length
        return false
      circles.addClass('middle')
      circles.eq(0).removeClass('middle').addClass('first')
      circles.eq(circles.length - 1).removeClass('middle').addClass('last')

    @addSortable()

  addSortable: ->
    @exerciseList = @$el.find '.gc-workout-exercises-list'

    @exerciseList.sortable
      pullPlaceholder: true
      handle: '.gc-workout-exercise-sort'
      onDrop: @onSortExercise
      onDragStart: @onDragStart

  onDragStart: ($item, container, _super) =>
    if not container.options.drop
      $item.clone().insertAfter($item)
      $item
      .removeClass 'dragged'
      .removeAttr 'style'
    _super $item, container


  onSortExercise: ($item, container, _super) =>
    draggable = $item.find 'span.gc-workout-exercise-sort'
    _super $item, container

    position = 1
    while( ($item = $item.prev()).length != 0 )
      position++

    @onSavePosition
      id: @workout.get 'id'
      workout_exercise_id: draggable.data 'workout-id'
      position: position

  onSavePosition: (data) =>
    @workoutExerciseModel = new WorkoutExerciseModel
    @workoutExerciseModel.url = "#{@workoutExerciseModel.urlRoot}/#{data.id}/workout_exercises/#{data.workout_exercise_id}"
    @workoutExerciseModel.set data
    @workoutExerciseModel.save()