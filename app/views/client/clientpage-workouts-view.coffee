Marionette = require 'backbone.marionette'

module.exports = class WorkoutsView extends Marionette.ItemView
  template: require '../../templates/client/workouts'
