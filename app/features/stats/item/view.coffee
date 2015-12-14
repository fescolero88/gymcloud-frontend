define [
  './template'
], (
  template
) ->

  class StatsItemView extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'row gc-folder'
