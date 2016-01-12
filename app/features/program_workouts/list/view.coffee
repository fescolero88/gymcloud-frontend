define [
  './item/view'
  './empty/view'
], (
  ItemView
  EmptyView
) ->

  class ProgramWorkoutsListView extends Marionette.CollectionView

    className: 'gc-program-workouts-list'

    childView: ItemView

    emptyView: EmptyView

    viewComparator: (model) ->
      model.get('position')

    initialize: ->
      @listenTo(@, 'actions:add', @_addWorkoutToCollection)
      @listenTo(@, 'actions:create', @_redirectToWorkouts)

    _addWorkoutToCollection: (id) ->
      model = @collection.add
        program_template_id:
          @collection.collection.program_template.get('id')
        workout_template_id: parseInt(id)
        position: @collection.length + 1
      model.save()

    _redirectToWorkouts: ->
      # @collection.add({})
      App.vent.trigger('redirect:to', '#/workout_templates')
