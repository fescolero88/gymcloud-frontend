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

    viewComparator: (model) ->
      model.get('position')

    initialize: ->
      @listenTo(@, 'actions:add', @_addWorkoutToCollection)
      @listenTo(@, 'actions:create', @_redirectToWorkouts)
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
        if @collection.week_id
          @_updateWeek()
        else
          @_updatePosition()

    _updateWeek: ->
      @collection.each (view) ->
        view.model.set
          position: view.$el.index()
          week_id: view.week_id
        view.model.patch()

    _updatePosition: ->
      @children.each (view) ->
        view.model.set
          position: view.$el.index()
        view.model.patch()
