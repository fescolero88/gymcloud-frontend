Marionette = require 'backbone.marionette'

module.exports = class ExercisesView extends Marionette.ItemView
  template: require '../../templates/client/exercises'
