define [
  './item/view'
  './empty/view'
], (
  ExercisesItemView
  EmptyView
) ->

  class WorkoutExercisesListView extends Marionette.CollectionView

    tagName: 'ul'

    className: 'gc-workout-exercises-list draggable-container'

    emptyView: EmptyView

    childView: ExercisesItemView

    initialize: ->
      App.request 'fwd',
        context: @
        from: @
        to: @children
        each: true
        events: [
          'actions:multi_constructor:start'
          'actions:multi_constructor:stop'
          'actions:multi_constructor:assign'
        ]

      @listenTo(@, 'actions:add', @_addExerciseToCollection)
      @listenTo(@, 'actions:create', @_redirectToExercises)
      @listenTo(@collection, 'add remove change', @_initConnections)
      @listenTo(App.vent, 'drag_n_drop:item:dropped', @_updatePosition)

    viewComparator: (model) ->
      model.get('position')

    onShow: ->
      @_initConnections()

    _addExerciseToCollection: (id) =>
      @collection.addExercise
        exercise_id: id
        workout_id: @model.get('id')
        order_name: @collection.length + 1
        position: @collection.length + 1

    _redirectToExercises: ->
      App.vent.trigger 'redirect:to', '#/exercises',
        replace: false

    _updatePosition: ->
      @children.each (view) ->
        view.model.set
          position: view.$el.index()
        view.model.patch()
      @collection.sort()

    _initConnections: ->
      colors = [
        '#4caf50', '#e91e63', '#9e9e9e', '#673ab7', '#ff9800', '#2196f3',
        '#ffeb3b', '#00bcd4', '#f44336', '#009688', '#8bc34a', '#cddc39',
        '#03a9f4', '#ffc107', '#3f51b5', '#ff5722', '#795548', '#9c27b0',
        '#607d8b'
      ]

      letterColors = {}
      lastColor = -1

      @collection.each (model, index) =>
        previous =
          @collection.models[index - 1]?.get('order_letter')
        next =
          @collection.models[index + 1]?.get('order_letter')
        current = model.get('order_letter')

        unless letterColors[current]
          lastColor = (lastColor + 1) % colors.length
          letterColors[current] = colors[lastColor]
        model.set
          color: letterColors[current]

        position =
          if current is '~'
            ''
          else if current is previous
            if current is next
              'middle'
            else
              'last'
          else if current is next
            'first'
          else
            ''

        model.set
          order_position: position