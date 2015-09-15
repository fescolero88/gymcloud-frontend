define ->

  class StickitBehavior extends Marionette.Behavior

    defaults: ->
      model: @view.model || undefined
      bindings: @view.bindings || {}

    onRender: ->
      @view.stickit(@options.model, @options.bindings)

    onDestroy: ->
      @view.unstickit(@options.model, @options.bindings)
