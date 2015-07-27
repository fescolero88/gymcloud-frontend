Marionette = require 'backbone.marionette'
WorkoutExercisePropertyModel = require 'models/trainer/workout-exercise-property-model'
PropertyCollection = require 'models/trainer/property-collection'

class WorkoutExercisePropertyItem extends Marionette.ItemView

  template: require 'templates/trainer/workouts/workout_exercise_property_item'

  tagName: 'li'

  ###
  collectionEvents:
    sync: 'render'
  ###

  initialize: ->
    # stores the selected property id from dropdown
    @collection = new PropertyCollection()
    @collection.fetch().then =>
      @render()

  onRender: ->
    console.log 'render', @collection
    # set defaults
    #set default property id
    @properties = @collection.toJSON()
    if @model.isNew()
      @model.set 'property_id', @properties[0]?.id
      @model.set 'property_value', @properties[0]?.defaultvalue
      @model.set 'property_name', @properties[0]?.name


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
    'keyup @ui.selectedPropertyValue': 'setPropertyValue'

  removeProperty: ->
    @model.trigger 'destroy', @model

  selectProperty: (ev) ->
    ev.preventDefault()
    @model.set 'property_id', ev.target.dataset.id
    @ui.selectedPropertyLabel.html(ev.target.innerHTML)
    @ui.selectedPropertyValue.html(ev.target.dataset.defaultValue)
    @model.set 'property_value', ev.target.dataset.defaultValue

  setPropertyValue: (ev) ->
    @model.set 'property_value', ev.target.innerHTML

module.exports = class WorkoutExercisePropertyConstructor extends Marionette.CompositeView

  template: require('templates/trainer/workouts/workout_exercise_property_constructor')

  childView: WorkoutExercisePropertyItem

  childViewContainer: 'ul.gc-workout-exercise-property-list'

  collectionEvents:
    remove: 'onModelRemoved'

  ui:
    addPropertyButton: 'a.gc-add-property-button'
    assignPropertyButton: '.gc-assign-property'

  events:
    'click @ui.addPropertyButton': 'addProperty'
    'click @ui.assignPropertyButton': 'assignProperties'

  addProperty: ->
    @collection.add new WorkoutExercisePropertyModel()
    @ui.assignPropertyButton.removeClass('hidden')
    # notify exercises that a property is being created
    App.vent.trigger 'exercise_property:select:enable'

  onModelRemoved: ->
    if @collection.length is 0
      @ui.assignPropertyButton.addClass('hidden')
      App.vent.trigger 'exercise_property:select:disable'

  assignProperties: ->
    App.vent.trigger 'exercise_property:assign', @collection.models
