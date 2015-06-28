Marionette = require 'backbone.marionette'
_ = require 'underscore'

class WorkoutGlobalClientView extends Marionette.ItemView

  tagName: 'li'

  template: Templates.trainer.workouts.workout_global_assign_client

  modelEvents:
    'model:toggle_assign:success': 'render'

  className: 'row gc-workout-client-item'

  events:
    'click': 'toggleAssign'

  toggleAssign: ->
    @model.toggleAssign()

  onRender: ->
    console.log @model.attributes

module.exports = class WorkoutGlobalAssignClientsListView extends Marionette.CompositeView

  template: Templates.trainer.workouts.workout_global_assign_clients

  className: 'gc-clients-list-wrapper gc-workouts-assign-list'

  collectionEvents:
    sync: 'applyIsAssignedProperty'

  initialize: (options) ->
    @clientAssignees = options.clientAssignees
    @workoutId = options.workoutId
    console.log options

  applyIsAssignedProperty: ->
    @collection.map (model) =>
      model.set 'workoutId', @workoutId # assign current workout id
      model.set 'isAssigned', _.contains(@clientAssignees, model.get('id'))
      return model
    @render()

  childView: WorkoutGlobalClientView

  childViewContainer: 'ul.gc-clients-list'

