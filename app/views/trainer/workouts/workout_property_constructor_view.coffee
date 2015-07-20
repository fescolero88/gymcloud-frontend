Marionette = require 'backbone.marionette'
WorkoutPropertyModel = require 'models/trainer/workout-property-model'
PropertyCollection = require 'models/trainer/property-collection'

class WorkoutPropertyItem extends Marionette.ItemView

  template: require 'templates/trainer/workouts/workout_property_item'

  tagName: 'li'

  collectionEvents:
    sync: 'render'

  initialize: ->
    # stores the selected property id from dropdown
    @selectedProperty = ''
    @collection = new PropertyCollection()
    @collection.fetch()

  templateHelpers: ->
    properties = @collection.toJSON()

    properties: properties
    defaultProperty: properties[0]?.name
    defaultPropertyValue: properties[0]?.defaultvalue

  ui:
    removeButton: '.gc-remove'
    propertyItem: '.gc-property-item'
    selectedPropertyLabel: '.gc-selected-property'
    selectedPropertyValue: '.gc-property-value'

  events:
    'click @ui.removeButton': 'removeProperty'
    'click @ui.propertyItem': 'selectProperty'

  removeProperty: ->
    @model.trigger 'destroy', @model

  selectProperty: (ev) ->
    ev.preventDefault()
    @selectedProperty = ev.target.dataset.id
    @ui.selectedPropertyLabel.html(ev.target.innerHTML)
    @ui.selectedPropertyValue.html(ev.target.dataset.defaultValue)

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
