define [
  'backbone.marionette'
  './template'
], (
  Marionette
  template
) ->
  class EmptyView extends Marionette.ItemView

    className: 'gc-properties-list-empty'

    template: template