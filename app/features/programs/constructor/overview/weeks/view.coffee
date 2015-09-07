define [
  'backbone.marionette'
  './item/view'
  './empty/view'
], (
  Marionette
  ProgramWeekItemView
  EmptyView
) ->

  class WeeksView extends Marionette.CollectionView

    className: 'gc-programs-weeks-list-container'

    ui:
      addWeek: '.gc-program-add-week'

    childView: ProgramWeekItemView

    childViewOptions: =>
      workoutsCollection: @workoutsCollection
      program: @model

    emptyView: EmptyView

    initialize: (options) ->
      @workoutsCollection = options.workoutsCollection
      App.vent.on 'program:remove:week', @removeWeek

    onDestroy: ->
      App.vent.off 'program:remove:week', @removeWeek

    events:
      'click @ui.addWeek': 'addNewWeek'

    addNewWeek: ->
      @collection.add(name: "Week #{@collection.length + 1}")
      App.request 'messenger:show',
        message: "Program week added."
        type: 'success'

    removeWeek: (model) =>
      @collection.remove model
      # TODO: delete workouts inside
      App.request 'messenger:show',
        message: "Program #{model.get('name')} has been removed."
        type: 'info'