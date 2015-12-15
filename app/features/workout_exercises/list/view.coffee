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
      #@listenTo(@collection, 'add', @showConnectionLines)
      #@listenTo(@collection, 'remove', @showConnectionLines)
      #@listenTo(@collection, 'change', @showConnectionLines)

      #@listenTo(@model, 'sync', @onSavedOrder)
      #@listenTo App.vent, 'sortables:on:drop', @onDropExercise

    _addExerciseToCollection: (id) =>
      @collection.addExercise
        exercise_id: id
        workout_id: @model.get('id')

    #onDestroy: ->
      #App.vent.trigger 'sortables:remove:container', @$el[0]

    #onRender: ->
      #@addSortable()
      #@showConnectionLines()
      #@addSidebarDraggable()

    #addSidebarDraggable: ->
      #App.vent.trigger 'sortables:add:container', @$el[0]

    #onDropExercise: (args) ->
      #if args.category is 'exercises'
        #args.container.removeChild(args.el)
        #App.vent.trigger 'workout:add:exercise', args

    #showConnectionLines: =>
      #circles = @$el.find(".gc-workout-exercise-circle[data-letter]")
      #colors = [
        #'#38cb73'
        #'#389adb'
        #'#fed929'
        #'#e54d40'
        #'#e459fe'
      #]
      #groupColors = {}
      #colorIndex = 0
      #previous = null

      #$.each circles, (index, item) ->
        #$item = $ item
        #letter = $item.data('letter').toLowerCase()
        #$item[0].className = 'gc-workout-exercise-circle'

        #if previous

          #if previous.data('letter').toLowerCase() == letter and letter != ''
            #$item.addClass 'last'

            #if previous.hasClass 'last'
              #previous.removeClass('last').addClass('middle')
            #else
              #previous.addClass('first')

          #else
            #$item.removeClass('last')
            #previous.removeClass('middle').removeClass('first')

        #if groupColors.hasOwnProperty(letter)
          #$item.css 'background-color', groupColors[letter]
        #else
          #groupColors[letter] = colors[colorIndex]
          #$item.css 'background-color', groupColors[letter]
          #colorIndex++

        #previous = $item

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
