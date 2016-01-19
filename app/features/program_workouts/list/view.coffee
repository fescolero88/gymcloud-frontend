define [
  './item/view'
  './empty/view'
  'models/program_workout'
], (
  ItemView
  EmptyView
  ProgramWorkout
) ->

  class ProgramWorkoutsListView extends Marionette.CollectionView

    className: 'gc-program-workouts-list draggable-container'

    childView: ItemView

    emptyView: EmptyView

    childEvents:
      'duplicate:program_workout': '_onDuplicate'

    initialize: ->
      @listenTo(@, 'actions:add', @_addWorkoutToCollection)
      @listenTo(@, 'actions:create', @_redirectToWorkouts)
      @listenTo(@collection, 'add remove', @_updatePosition)
      @listenTo(App.vent, 'drag_n_drop:item:dropped', @_handleDropped)

    _addWorkoutToCollection: (id) ->
      attrs =
        program_template_id:
          @collection.collection.program_template.get('id')
        workout_template_id: parseInt(id)
        position: @collection.length + 1
      Model = @collection.collection.model
      model = new Model(attrs)
      model.save()
        .then =>
          @collection.collection.add(model)

    _redirectToWorkouts: ->
      # @collection.add({})
      App.vent.trigger 'redirect:to', '#/workout_templates',
        replace: false

    _onDuplicate: (childView) ->
      programWorkout = childView.model

      newProgramWorkout = new ProgramWorkout
        program_template_id: programWorkout.get('program_id')
        workout_template_id: programWorkout.get('workout_id')
        position: @collection.length + 1
        week_id: programWorkout.get('week_id')

      newProgramWorkout.save({}, wait: true).then =>
        @collection.add(newProgramWorkout)

    _handleDropped: (el, target, source, sibling) ->
      if target is @el
        App.vent.trigger('dropped:to:week', el, @collection.week_id or null)
        @_updatePosition(el)

    _updatePosition: (el) ->
      @children.each (view) =>
        id = view.$el.data('id')
        model = @collection.collection.find(id: id)
        return unless model
        model.set
          position: view.$el.index()
        model.patch()
