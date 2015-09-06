define [
  'backbone.marionette'
  './template'
], (
  Marionette
  template
)->
  class PersonalCollectionItemView extends Marionette.ItemView

    template: template

    className: 'gc-sidebar-item'

    templateHelpers: ->
      type: @type

    initialize: (options)->
      @type = options.type