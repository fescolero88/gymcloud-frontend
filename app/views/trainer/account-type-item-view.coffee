define [
  'backbone.marionette'
  'templates/trainer/account-type-item'
], (
  Marionette
  template
) ->
  class AccountTypeItemView extends Marionette.ItemView

    tagName: 'li'

    className: 'gc-account-type-item'

    template: template

    events:
      'click': 'changeAssignment'

    bindings:
      ':el':
        observe: 'assigned'
        update: ($el, val, model, options) =>
          if model.get 'assigned'
            $el.addClass 'active'
          else
            $el.removeClass 'active'

    onRender: ->
      _.extend(this.constructor.prototype, Backbone.Stickit.ViewMixin)
      @stickit()

    onDestroy: ->
      @unstickit()

    changeAssignment: ->
      @triggerMethod 'assignment:changed', 'test'
      @model.set 'assigned', !@model.get('assigned')