define [
  './item/view'
  './empty/view'
], (
  ProgramWeekItemView
  EmptyView
) ->

  class WeeksView extends Marionette.CollectionView

    className: 'gc-programs-weeks-list-container'

    ui:
      addWeek: '.gc-program-add-week'

    emptyView: EmptyView

    childView: ProgramWeekItemView

    childViewOptions: =>
      program: @model

    childEvents: =>
      'add:program_workout': @addProgramWorkout

    events:
      'click @ui.addWeek': 'addNewWeek'

    addNewWeek: ->
      @collection.add(name: "Week #{@collection.length + 1}")
      App.request 'messenger:show',
        message: "Program week added."
        type: 'success'

    addProgramWorkout: ->
      @trigger('add:program_workout')