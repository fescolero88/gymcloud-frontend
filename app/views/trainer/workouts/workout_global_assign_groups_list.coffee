Marionette = require 'backbone.marionette'
_ = require 'underscore'

class WorkoutGlobalGroupView extends Marionette.ItemView
  tagName:'li'

  template: Templates.trainer.workouts.workout_global_assign_group

  className: 'row'

module.exports = class WorkoutGlobalAssignGroupsListView extends Marionette.CompositeView

  template: Templates.trainer.workouts.workout_global_assign_groups

  className: 'gc-clients-list-wrapper gc-workouts-assign-list'

  collectionEvents:
    sync: 'applyIsAssignedProperty'

  childView: WorkoutGlobalGroupView

  initialize: (options) ->
    @clientGroupsAssignees = options.groupAssignees

  childViewContainer: 'ul.gc-clients-list'

  applyIsAssignedProperty: ->
    @collection.map (model) ->
      model.set 'isAssigned', _.contains(@clientGroupsAssignees, model.get('id'))
      return model

