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

    behaviors:
      exercises_connectors: true

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
      #@listenTo(@model, 'sync', @onSavedOrder)
      #@listenTo App.vent, 'sortables:on:drop', @onDropExercise

    _addExerciseToCollection: (id) =>
      @collection.addExercise
        exercise_id: id
        workout_id: @model.get('id')
        order_name: @collection.length + 1
        position: @collection.length + 1

    _redirectToExercises: ->
      App.vent.trigger 'redirect:to', '#/exercises',
        replace: false

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
