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

    modelEvents:
      'change:assigned': 'setStatus'

    events:
      'click': 'changeAssignment'

    initialize: ->
      App.vent.on 'account:changed', @unAssignAccount

    onDestroy: ->
      App.vent.off 'account:changed', @unAssignAccount

    unAssignAccount: =>
      if @model.get 'assigned'
        @model.set 'assigned', false

    onShow: ->
      @setStatus()

    changeAssignment: ->
      App.vent.trigger 'account:changed'
      @model.set 'assigned', !@model.get('assigned')

    setStatus: ->
      if @model.get 'assigned'
        @$el.addClass 'active'
        #update model here
      else
        @$el.removeClass 'active'

