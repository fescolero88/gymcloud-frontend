Marionette = require 'backbone.marionette'

module.exports = class ExerciseView extends Marionette.ItemView

  template: require('templates/trainer/exercises/exercise')

  modelEvents:
    sync: 'render'
    change: 'render'
