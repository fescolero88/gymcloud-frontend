define [
  'backbone.marionette'
  'templates/sidebar/sidebar_item'
], (
  Marionette
  template
)->
  class TemplateCollectionItemView extends Marionette.ItemView

    template: template

    className: 'gc-sidebar-item'

    templateHelpers: ->
      type: @type
      isFolder: false

    initialize: (options)->
      @type = options.type