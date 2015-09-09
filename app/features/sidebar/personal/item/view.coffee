define [
  './template'
], (
  template
)->
  class PersonalCollectionItemView extends Marionette.ItemView

    template: template

    className: 'gc-sidebar-item'

    bindings:
      '[data-bind="name"]': 'name'

    templateHelpers: ->
      type: @type

    initialize: (options)->
      @type = options.type

    onRender: ->
      _.extend(this.constructor.prototype, Backbone.Stickit.ViewMixin)
      @stickit()

    onDestroy: ->
      @unstickit()
