class WorkoutGlobalGroupView extends Marionette.ItemView
  tagName:'li'

  template: require('templates/trainer/workouts/workout_global_assign_group')

  modelEvents:
    'model:toggle_assign:success': 'toggleAssignSuccess'

  className: 'row gc-workout-group-item'

  events:
    'click': 'toggleAssign'

  toggleAssign: ->
    @model.toggleAssign()

  toggleAssignSuccess: (response, actionType) ->
    if actionType is 'assign'
      message = 'This workout was assigned to this client'
    else
      message = 'This workout was unassigned to this client'
    App.request 'messenger:show',
      message: message
    @render()


module.exports = class WorkoutGlobalAssignGroupsListView extends Marionette.CompositeView

  template: require('templates/trainer/workouts/workout_global_assign_groups')

  className: 'gc-clients-list-wrapper gc-workouts-assign-list'

  collectionEvents:
    sync: 'applyIsAssignedProperty'

  childView: WorkoutGlobalGroupView

  initialize: (options) ->
    @clientGroupsAssignees = options.groupAssignees
    @workoutId = options.workoutId

  childViewContainer: 'ul.gc-clients-list'

  applyIsAssignedProperty: ->
    @collection.map (model) =>
      model.set 'workoutId', @workoutId # assign current workout id
      model.set 'isAssigned', _.contains(@clientGroupsAssignees, model.get('id'))
      return model
    @render()
