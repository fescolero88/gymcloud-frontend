WorkoutExerciseProperty = require 'models/workout_exercise_property'
Properties = require 'collections/properties'

class WorkoutExercisePropertyItem extends Marionette.ItemView

  template: require 'templates/trainer/workouts/workout_exercise_property_item'

  tagName: 'li'

  className: 'pull-left'

  initialize: ->
    # stores the selected property id from dropdown
    @collection = new Properties
    @collection.fetch().then =>
      @render()

  onRender: ->
    #set default property id
    @properties = @collection.toJSON()
    if @model.isNew()
      @model.set 'property_id', @properties[0]?.id
      @ui.selectedPropertyValue.focus()
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
    @ui.selectedPropertyValue.focus()

  setPropertyValue: (ev) ->
    @model.set 'property_value', ev.target.innerHTML

module.exports = class WorkoutExercisePropertyConstructor extends Marionette.CompositeView

  template: require('templates/trainer/workouts/workout_exercise_property_constructor')

  childView: WorkoutExercisePropertyItem

  childViewContainer: 'ul.gc-workout-exercise-property-list'

  collectionEvents:
    remove: 'onModelRemoved'

  initialize: ->
    @listenerCount = 0
    @syncedExercises = 0
    App.commands.setHandler 'property_constructor:update_listeners_count', @updateListenerCount
    App.commands.setHandler 'property_constructor:synced:add', @addSyncedCount
    App.commands.setHandler 'workout_exercises:property:added', @hideEmptyState

  onRender: ->
    if not App.request 'workout_exercises:has_exercise_properties?'
      @ui.emptyState.removeClass 'hidden'

  onDestroy: ->
    App.commands.removeListener 'property_constructor:update_listeners_count', @updateListenerCount
    App.commands.removeListener 'property_constructor:synced:add', @addSyncedCount
    App.commands.removeListener 'workout_exercises:property:added', @hideEmptyState

  ui:
    addPropertyButton: 'a.gc-add-property-button'
    assignPropertyButton: '.gc-assign-property'
    emptyState: '.gc-constructor-empty-state'

  events:
    'click @ui.addPropertyButton': 'addProperty'
    'click @ui.assignPropertyButton': 'assignProperties'

  addProperty: ->
    # hide empty state p if shown
    @hideEmptyState()
    if App.request 'workout_exercises:has_exercise?'
      @collection.add new WorkoutExerciseProperty, sort: false
      @ui.assignPropertyButton.removeClass('hidden')
      # notify exercises that a property is being created
      App.vent.trigger 'exercise_property:select:enable'

  onModelRemoved: ->
    if @collection.length is 0
      @ui.assignPropertyButton.addClass('hidden')
      App.vent.trigger 'exercise_property:select:disable'

  assignProperties: ->
    App.vent.trigger 'exercise_property:assign', @collection.models

  updateListenerCount: (val) =>
    @listenerCount += val

  addSyncedCount: =>
    @syncedExercises += 1
    if @syncedExercises is @listenerCount
      @collection.reset null
      @syncedExercises = 0
      @listenerCount = 0
      @ui.assignPropertyButton.addClass('hidden')
      App.vent.trigger 'exercise_property:select:disable'
      App.request 'messenger:show',
        message: 'Properties Saved'

  hideEmptyState: =>
    if not @ui.emptyState.hasClass('hidden')
      @ui.emptyState.addClass('hidden')
