define [
  './property_constructor/view'
  'collections/workout_exercise_properties'
  './item/view'
  'models/workout_exercise'
  './empty/view'
  './template'
], (
  PropertyConstructor
  WorkoutExerciseProperties
  ExercisesItemView
  WorkoutExercise
  EmptyView
  template
) ->

  class WorkoutExercisesView extends Marionette.CompositeView

    template: template

    className: 'gc-workouts-exercises-view'

    emptyView: EmptyView

    childView: ExercisesItemView

    childViewContainer: 'ul'

    childViewOptions: (model) ->
      collection: model.properties
      visibleProperties: @visibleProperties

    viewComparator: (model) ->
      model.get('position')

    behaviors: ->

      auto_complete:
        onItemAdd: ((_this) ->
          (value, $item) ->
            this.clear()
            _this.addExercise(value, $item)
        )(this)
        collection: ->
          App.request('current_user').exercises.map (item) ->
            folder: item.folder?.name
            id: item.get('id')
            name: item.get('name')
            label: item.get('name')

    ui:
      circles: '.gc-workout-exercise-circle'
      liveSearch: '.live-search'
      searchContainer: '.gc-exercises-assign-input-wrapper'
      workoutExercisePropertyConstructorWrapper: 'region[data-name="workout-property-constructor"]'

    templateHelpers: =>
      currentUserId: App.request('current_user_id')
      workout: @workout.attributes

    initialize: (data) =>
      @visibleProperties = @_getVisibleProperties()
      @workout = data.workout
      @listenTo(@collection, 'add', @showConnectionLines)
      @listenTo(@collection, 'remove', @showConnectionLines)
      @listenTo(@collection, 'change', @showConnectionLines)
      App.vent.on 'workout:reload:exercises', @getWorkoutData

      @workoutExerciseModel = new WorkoutExercise
      @listenTo(@workoutExerciseModel, 'sync', @onSavedOrder)
      # sends the collection count
      App.reqres.setHandler 'workout_exercises:has_exercise?', @_hasExercise
      App.reqres.setHandler 'workout_exercises:has_exercise_properties?', @_hasExerciseProperties

    onDestroy: ->
      App.vent.off 'workout:reload:exercises', @getWorkoutData
      App.reqres.removeHandler 'workout_exercises:has_exercise?', @_hasExercise
      App.reqres.removeHandler 'workout_exercises:has_exercise_properties?', @_hasExerciseProperties
      @propertyConstructorView.destroy()

    onRender: ->
      @propertyConstructorView = new PropertyConstructor
        collection: new Backbone.Collection()
        visibleProperties: @visibleProperties
      @propertyConstructorView.render()
      el = @propertyConstructorView.el

      @ui.workoutExercisePropertyConstructorWrapper.html(el)

      @addSortable()
      @showConnectionLines()

    getWorkoutData: =>
      @workout.fetch()

    showConnectionLines: =>
      circles = @$el.find(".gc-workout-exercise-circle[data-letter]")
      colors = [
        '#38cb73'
        '#389adb'
        '#fed929'
        '#e54d40'
        '#e459fe'
      ]
      groupColors = {}
      colorIndex = 0
      previous = null

      $.each circles, (index, item) ->
        $item = $ item
        letter = $item.data('letter').toLowerCase()
        $item[0].className = 'gc-workout-exercise-circle'

        if previous

          if previous.data('letter').toLowerCase() == letter and letter != ''
            $item.addClass 'last'

            if previous.hasClass 'last'
              previous.removeClass('last').addClass('middle')
            else
              previous.addClass('first')

          else
            $item.removeClass('last')
            previous.removeClass('middle').removeClass('first')

        if groupColors.hasOwnProperty(letter)
          $item.css 'background-color', groupColors[letter]
        else
          groupColors[letter] = colors[colorIndex]
          $item.css 'background-color', groupColors[letter]
          colorIndex++

        previous = $item

    addSortable: ->
      @exerciseList = @$el.find '.gc-workout-exercises-list'

      @exerciseList.sortable
        pullPlaceholder: true
        handle: '.gc-workout-exercise-sort'
        onDrop: @onSortExercise
        onDragStart: @onDragStart

    onDragStart: ($item, container, _super) =>
      if not container.options.drop
        $item.clone().insertAfter($item)
        $item
        .removeClass 'dragged'
        .removeAttr 'style'
      _super $item, container

    onSortExercise: ($item, container, _super) =>
      draggable = $item.find 'span.gc-workout-exercise-sort'
      _super $item, container

      model = @collection.get id: draggable.data 'workout-id'
      prevPos = model.get 'position'
      currPos = $item.index()
      currPos += 1
      @collection.remove model
      @collection.add model, at:currPos-1
      @fixExercisesPositions()

      exerciseIds = @collection.pluck 'id'
      @onSavePosition
        exercises_ordered_ids: exerciseIds

    fixExercisesPositions: ->
      @collection.each (model, i) ->
        model.set 'position', i+1

    onSavePosition: (data) =>
      @workoutExerciseModel.url = "#{@workoutExerciseModel.urlRoot}/#{@workout.get 'id'}/workout_exercises/resort"
      @workoutExerciseModel.method = 'patch'
      @workoutExerciseModel.save(data)

    onSavedOrder: ->
      App.request 'messenger:show',
        hideAfter: 5
        message: "Order Position Saved."
        type: 'success'

      @showConnectionLines()

    addExercise: (value, $item) ->
      data =
        category: 'exercises'
        id: value
      App.vent.trigger 'workout:add:exercise', data

    _hasExercise: =>
      @collection.length > 0

    _hasExerciseProperties: =>
      length = 0
      @collection.models.forEach (exercise) ->
        length += exercise.properties.length

      return length > 0

    _getVisibleProperties: ->
      currentUser = App.request('current_user')
      collection = currentUser.personal_properties
      properties = collection.where(is_visible: true)
