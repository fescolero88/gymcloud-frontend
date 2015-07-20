Marionette = require 'backbone.marionette'
WorkoutPropertyModel = require 'models/trainer/workout-property-model'
PropertyCollection = require 'models/trainer/property-collection'

class WorkoutPropertyItem extends Marionette.ItemView

  template: require 'templates/trainer/workouts/workout_property_item'

  tagName: 'li'

  collectionEvents:
    sync: 'render'

  initialize: ->
    @collection = new PropertyCollection()
    @collection.fetch().then =>
      @render()

  templateHelpers: ->
    properties = @collection.toJSON()

    properties: properties
    defaultProperty: properties[0]?.name

  onRender: ->
    console.log @collection.at 0
  ui:
    removeButton: '.gc-remove'

  events:
    'click @ui.removeButton': 'removeProperty'

  removeProperty: ->
    @model.trigger 'destroy', @model


module.exports = class WorkoutPropertyConstructor extends Marionette.CompositeView

  template: require('templates/trainer/workouts/workout_property_constructor')

  childView: WorkoutPropertyItem

  childViewContainer: 'ul.gc-workout-property-list'

  initialize: ->
    console.log 'property constructor', @collection

  ui:
    addPropertyButton: 'a.gc-add-property-button'

  events:
    'click @ui.addPropertyButton': 'addProperty'

  addProperty: ->
    @collection.add new WorkoutPropertyModel()
