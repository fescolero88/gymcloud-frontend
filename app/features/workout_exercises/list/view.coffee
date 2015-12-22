define [
  './item/view'
  './empty/view'
  'dragula'
], (
  ExercisesItemView
  EmptyView
  Dragula
) ->

  class WorkoutExercisesListView extends Marionette.CollectionView

    tagName: 'ul'

    className: 'gc-workout-exercises-list'

    emptyView: EmptyView

    childView: ExercisesItemView

    viewComparator: (model) ->
      model.get('position')

    initialize: (data) =>
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
      @listenTo(@collection, 'add remove change', @_initConnections)
      #@listenTo(@model, 'sync', @onSavedOrder)
      #@listenTo App.vent, 'sortables:on:drop', @onDropExercise

    onShow: ->
      @_initConnections()

    _addExerciseToCollection: (id) =>
      @collection.addExercise
        exercise_id: id
        workout_id: @model.get('id')
        order_name: @collection.length + 1

    #onDestroy: ->
      #App.vent.trigger 'sortables:remove:container', @$el[0]

    #onRender: ->
      #@addSortable()
      #@addSidebarDraggable()

    #addSidebarDraggable: ->
      #App.vent.trigger 'sortables:add:container', @$el[0]

    #onDropExercise: (args) ->
      #if args.category is 'exercises'
        #args.container.removeChild(args.el)
        #App.vent.trigger 'workout:add:exercise', args

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

    #addSortable: ->
      #dragOptions =
        #revertOnSpill: true
        #moves: (el, container, handle) ->
          #$(handle).has('.gc-workout-exercise-name')

      #Dragula [@$el[0]], dragOptions
        #.on 'drop', (el, container) =>
          #draggable = $(el).find 'span.gc-workout-exercise-sort'
          #pos = $(el).index()

          #model = @collection.get id: draggable.data('workout-id')
          #@collection.remove model
          #@collection.add model, at:pos
          #@fixExercisesPositions()
          #@children.call '_positionChanged'

    #fixExercisesPositions: ->
      #@collection.each (model, i) ->
        #model.set 'position', i+1

    #onSavedOrder: ->
      #@showConnectionLines()
