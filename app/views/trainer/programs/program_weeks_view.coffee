Marionette = require 'backbone.marionette'
ProgramWeekItemView = require 'views/trainer/programs/program_week_item_view'

module.exports = class ProgramWeeksView extends Marionette.CompositeView

  template: require('templates/trainer/programs/program_weeks')

  ui:
    addWeek: '.gc-program-add-week'

  childViewContainer: '.gc-programs-weeks-list-container'

  childView: ProgramWeekItemView

  initialize: ->
    App.vent.on 'program:remove:week', @removeWeek

  onDestroy: ->
    App.vent.off 'program:remove:week', @removeWeek

  events:
    'click @ui.addWeek': 'addNewWeek'

  addNewWeek: ->
    data =
      id: @collection.length + 1
      name: "Week #{@collection.length + 1}"
    @collection.add(data)
    App.request 'messenger:show',
      message: "Program week added."
      type: 'success'

  removeWeek: (model) =>
    @collection.remove model
    App.request 'messenger:show',
      message: "Program #{model.get('name')} has been removed."
      type: 'info'
