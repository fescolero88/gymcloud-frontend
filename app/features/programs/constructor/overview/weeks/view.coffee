define [
  './item/view'
  './empty/view'
  'models/program_week'
], (
  ProgramWeekItemView
  EmptyView
  ProgramWeek
) ->

  class WeeksView extends Marionette.CollectionView

    className: 'gc-programs-weeks-list-container'

    ui:
      addWeek: '.gc-program-add-week'

    emptyView: EmptyView

    childView: ProgramWeekItemView

    childViewOptions: =>
      program: @model
      sortable: @sortable

    childEvents: =>
      'add:program_workout': @addProgramWorkout
      'add:program_workout_from_library': @_addProgramWorkoutFromLibrary

    events:
      'click @ui.addWeek': 'addNewWeek'

    viewComparator: (model) ->
      model.get 'position'

    initialize: (options) ->
      App.vent.on 'add:program:week', @addNewWeek
      @sortable = options.sortable
      @listenTo this, 'remove:child', @onItemRemoved

    onDestroy: ->
      App.vent.off 'add:program:week', @addNewWeek

    addNewWeek: =>
      position = @collection.length + 1
      programWeek = new ProgramWeek
        name: "Week #{position}"
        position: position
        program_id: @model.get('id')

      programWeek.save().then =>
        @collection.add(programWeek)
        App.request 'messenger:show',
          message: "Program week added."
          type: 'success'

    addProgramWorkout: ->
      @trigger('add:program_workout')

    _addProgramWorkoutFromLibrary: (parent, workoutId) =>
      @trigger('add:program_workout:from_library', workoutId)

    onItemRemoved: ->
      @.children.call '_assignWeekPosition'
