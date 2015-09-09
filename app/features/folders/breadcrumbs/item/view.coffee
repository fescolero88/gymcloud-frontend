define [
  'backbone.marionette'
  './template'
], (
  Marionette
  template
) ->

  class BreadcrumbsItemView extends Marionette.ItemView

    template: template

    tagName: 'span'

    initialize: ->
      debugger