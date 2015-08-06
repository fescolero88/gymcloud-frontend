Marionette = require 'backbone.marionette'

module.exports = class ProgramWeekItemView extends Marionette.ItemView

  template: require 'templates/trainer/programs/program_week_item'

  tagName: 'div'

  className: 'gc-program-week-item'

  ui:
    removeWeek: '.gc-remove-program-week'

  events:
    'click @ui.removeWeek': 'removeProgramWeek'

  removeProgramWeek: ->
    App.vent.trigger 'program:remove:week', @model