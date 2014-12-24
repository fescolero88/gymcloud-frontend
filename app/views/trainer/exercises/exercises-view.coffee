Marionette = require 'backbone.marionette'

module.exports = class ExercisesView extends Marionette.ItemView

  template: ->
    if Math.round(Math.random())
        require '../../../templates/trainer/exercises/exercises'
    else
        require '../../../templates/trainer/exercises/exercises-empty'

