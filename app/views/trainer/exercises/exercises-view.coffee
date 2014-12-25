Marionette = require 'backbone.marionette'
exercisesTemplate = require '../../../templates/trainer/exercises/exercises'
exercisesEmptyTempate = require '../../../templates/trainer/exercises/exercises-empty'

module.exports = class ExercisesView extends Marionette.ItemView

  template: ->
    if Math.round(Math.random())
        exercisesTemplate
    else
        exercisesEmptyTempate
