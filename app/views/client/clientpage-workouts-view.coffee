Marionette = require 'backbone.marionette'
myTemplate = require '../../templates/client/workouts'

module.exports = class WorkoutsView extends Marionette.ItemView
  template: myTemplate
