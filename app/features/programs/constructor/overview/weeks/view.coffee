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

    childEvents: =>
      'add:program_workout': @addProgramWorkout

    events:
      'click @ui.addWeek': 'addNewWeek'

    initialize: ->
      App.vent.on 'add:program:week', @addNewWeek

    onDestroy: ->
      App.vent.off 'add:program:week', @addNewWeek

    addNewWeek: =>
      position = @collection.length + 1
      proramWeek = new ProgramWeek
        name: "Week #{position}"
        position: position
        program_id: @model.get('id')

      proramWeek.save().then =>
        @collection.add(proramWeek)
        App.request 'messenger:show',
          message: "Program week added."
          type: 'success'

    addProgramWorkout: ->
      @trigger('add:program_workout')