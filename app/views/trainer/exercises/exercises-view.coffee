Marionette = require 'backbone.marionette'

module.exports = class ExercisesView extends Marionette.ItemView

  initialize: =>
    super
    r = Math.round(Math.random())
    if r
        @template = require '../../../templates/trainer/exercises/exercises'
    else
        @template = require '../../../templates/trainer/exercises/exercises-empty'

