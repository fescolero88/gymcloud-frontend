define [
  './template'
], (
  template
) ->

  class ClientPerformanceItemView extends Marionette.ItemView

    template: template

    tagName: 'tr'
