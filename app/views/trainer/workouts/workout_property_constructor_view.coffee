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
    @model.set 'property_id', ev.target.dataset.id
    @ui.selectedPropertyLabel.html(ev.target.innerHTML)
    @ui.selectedPropertyValue.html(ev.target.dataset.defaultValue)
    @model.set 'property_value', ev.target.dataset.defaultValue

module.exports = class WorkoutPropertyConstructor extends Marionette.CompositeView

  template: require('templates/trainer/workouts/workout_property_constructor')

  childView: WorkoutPropertyItem

  childViewContainer: 'ul.gc-workout-property-list'

  collectionEvents:
    remove: 'onModelRemoved'

  ui:
    addPropertyButton: 'a.gc-add-property-button'
    assignPropertyButton: '.gc-assign-property'

  events:
    'click @ui.addPropertyButton': 'addProperty'
    'click @ui.assignPropertyButton': 'assignProperties'

  addProperty: ->
    @collection.add new WorkoutPropertyModel()
    @ui.assignPropertyButton.removeClass('hidden')
    # notify exercises that a property is being created
    App.vent.trigger 'exercise_property:select:enable'

  onModelRemoved: ->
    if @collection.length is 0
      @ui.assignPropertyButton.addClass('hidden')
      App.vent.trigger 'exercise_property:select:disable'

  assignProperties: ->
    console.log 'triggered assign button'
    App.vent.trigger 'exercise_property:assign', @collection.toJSON()
