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

    getEmptyView: ->
      @options.hasEmptyView && EmptyView

    childEvents:
      'duplicate:program_workout': '_onDuplicate'
      'actions:create': '_onCreate'
      'actions:add': '_quickAddWorkoutToCollection'

    initialize: ->
      @listenTo(@, 'actions:add', @_addWorkoutToCollection)
      @listenTo(@, 'actions:create', @_onCreate)
      @listenTo(@, 'actions:create', @_redirectToWorkouts)
      @listenTo(@collection, 'add remove', @_updatePosition)
      @listenTo(App.vent, 'drag_n_drop:item:dropped', @_handleDropped)

    _quickAddWorkoutToCollection: (_childView, id) ->
      @trigger('actions:add', id)

    _addWorkoutToCollection: (id) ->
      attrs =
        program_template_id:
          @collection.collection.program_template.get('id')
        workout_template_id: parseInt(id)
        position: @collection.length + 1
        week_id: @options.weekId
      @collection.collection.create(attrs, wait: true)

    _onDuplicate: (childView) ->
      programWorkout = childView.model

      newProgramWorkout = new ProgramWorkout
        program_template_id: programWorkout.get('program_id')
        workout_template_id: programWorkout.get('workout_id')
        position: @collection.length + 1
        week_id: programWorkout.get('week_id')

      newProgramWorkout.save({}, wait: true).then =>
        @collection.add(newProgramWorkout)

    _onCreate: ->
      newProgramWorkout = new ProgramWorkout
        program_template_id: @model.get('id')
        position: @collection.length + 1
        week_id: @options.weekId

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
