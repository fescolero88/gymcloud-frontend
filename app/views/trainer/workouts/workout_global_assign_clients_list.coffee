Marionette = require 'backbone.marionette'
_ = require 'underscore'

class WorkoutGlobalClientView extends Marionette.ItemView

  tagName: 'li'

  template: Templates.trainer.workouts.workout_global_assign_client

  onRender: ->
    console.log 'attrs', @model.attributes

  className: 'row'

module.exports = class WorkoutGlobalAssignClientsListView extends Marionette.CompositeView

  template: Templates.trainer.workouts.workout_global_assign_clients

  className: 'gc-clients-list-wrapper gc-workouts-assign-list'

  collectionEvents:
    sync: 'applyIsAssignedProperty'

  initialize: (options) ->
    @clientAssignees = options.clientAssignees

  applyIsAssignedProperty: ->
    @collection.map (model) ->
      model.set 'isAssigned', _.contains(@clientAssignees, model.get('id'))
      return model

  childView: WorkoutGlobalClientView

  childViewContainer: 'ul.gc-clients-list'

