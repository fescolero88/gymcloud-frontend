Marionette = require 'backbone.marionette'
myTemplate = require '../../templates/client/exercises'

module.exports = class ExercisesView extends Marionette.ItemView
  template: myTemplate
