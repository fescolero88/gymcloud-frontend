define [
  'backbone.marionette'
  './template'
], (
  Marionette
  template
) ->
  class EmptyView extends Marionette.ItemView

    template: template