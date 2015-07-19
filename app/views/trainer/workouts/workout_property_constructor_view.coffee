Marionette = require 'backbone.marionette'

module.exports = class WorkoutPropertyConstructor extends Marionette.CompositeView
  template: require('templates/trainer/workouts/workout_property_constructor')

  ui:
    addPropertyButton: 'a.gc-add-property-button'

  events:
    'click @ui.addPropertyButton': 'addProperty'

  addProperty: ->
    alert 'adding property'
    
