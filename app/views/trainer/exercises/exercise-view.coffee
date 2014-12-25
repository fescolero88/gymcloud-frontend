Marionette = require 'backbone.marionette'
myTemplate = require '../../../templates/trainer/exercises/exercise'

module.exports = class ExerciseView extends Marionette.ItemView

  initialize: =>
    @template = myTemplate
