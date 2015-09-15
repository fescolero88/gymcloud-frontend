define ->

  class StickitBehavior extends Marionette.Behavior

    defaults: ->
      model: @view.model || undefined
      bindings: @view.bindings || {}

    onRender: ->
      @view.stickit(@_stickitArgs()...)

    onDestroy: ->
      @view.unstickit(@_stickitArgs()...)

    _stickitArgs: ->
      [
        _.result(@options, 'model')
        _.result(@options, 'bindings')
      ]
