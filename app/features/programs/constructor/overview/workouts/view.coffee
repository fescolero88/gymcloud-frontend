define [
  './item/view'
  'models/workout_template'
  'models/program_workout'
], (
  ProgramGlobalWorkoutItemView
  WorkoutTemplate
  ProgramWorkout
) ->
  class WorkoutListView extends Marionette.CollectionView

    tagName: 'ul'

    className: 'gc-program-workouts-list'

    childView: ProgramGlobalWorkoutItemView

    childViewOptions: =>
      program_template: @program

    addChild: (child, ChildView, index) ->
      unless child.isInWeek
        Marionette.CollectionView::addChild.apply this, arguments

    viewComparator: (model) ->
      model.get 'position'

    initialize: (options) ->
      @sortable = options.sortable
      @program = options.program
      @weekId = options.weekId || ''
      @el.setAttribute 'data-week-id', @weekId
      App.vent.on 'add:program:workout', @reorderProgramWorkouts

    onDestroy: ->
      App.vent.off 'add:program:workout', @reorderProgramWorkouts

    onShow: ->
      @addSortable()

    addSortable: ->
      @sortable.containers.push @el
      @sortable.on 'drop', (el, container) =>
        newWeekId = container.getAttribute('data-week-id')
        model = @collection.findWhere
          'id': parseInt(el.getAttribute('data-id'))

        if model and model.get('week_id') isnt newWeekId
          position = $(el).index()
          model.save(
            'week_id': newWeekId
          ,
            wait: true
          ).then =>
            @collection.remove model
            App.vent.trigger 'add:program:workout', model, position
            App.request 'messenger:show',
              message: "Workout successfully moved."
              type: 'success'
        else if @el is container
          @.children.call '_positionChanged'

    reorderProgramWorkouts: (model, index) =>
      itemWeekId = model.get('week_id') || ''
      if @weekId is itemWeekId
        @collection.add model,
          at: index
        @children.call '_positionChanged'

        if itemWeekId isnt ''
          App.vent.trigger 'add:week:workout:count'

    addProgramWorkout: (isInWeek = false) =>
      workout = new WorkoutTemplate
        name: "Workout #{@collection.length + 1}"
        is_visible: false
        position: @collection.length + 1
      workout.save().then =>
        model = new ProgramWorkout
          workout_template_id: workout.id
          program_template_id: @program.id
        model.isInWeek = isInWeek
        model.save().then =>
          @collection.add(model)
          @program.program_workouts.add(model)

    addProgramWorkoutFromLibrary: (workoutId, isInWeek = false) ->
      model = new ProgramWorkout
        workout_template_id: workoutId
        program_template_id: @program.id
        position: @collection.length + 1

      model.isInWeek = isInWeek
      model.save().then =>
        @collection.add(model)
        @program.program_workouts.add(model)