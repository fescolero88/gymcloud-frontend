Marionette = require 'backbone.marionette'

class WorkoutGlobalClientView extends Marionette.ItemView

  tagName: 'li'

  template: Templates.trainer.workouts.workout_global_assign_client

  className: 'row'

module.exports = class WorkoutGlobalAssignClientsListView extends Marionette.CompositeView

  template: Templates.trainer.workouts.workout_global_assign_clients

  className: 'gc-clients-list-wrapper gc-workouts-assign-clients-list'

  childView: WorkoutGlobalClientView

  childViewContainer: 'ul.gc-clients-list'

