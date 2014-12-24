Marionette = require 'backbone.marionette'

module.exports = class ExerciseView extends Marionette.ItemView

  initialize: =>
    @template = require '../../../templates/trainer/exercises/exercise'
