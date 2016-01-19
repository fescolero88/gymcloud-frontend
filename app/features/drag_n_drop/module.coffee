define [
  'dragula'
], (
  Dragula
) ->

  class Module extends Marionette.Module

    initialize: ->
      @_initInstance()
      @_initHandlers()

    _initInstance: ->
      options =
        isContainer: (el) ->
          el.classList.contains('draggable-container')
        moves: (el, source, handle, sibling) ->
          handle.classList.contains('draggable-handle')
        accepts: (el, target, source, sibling) ->
          $el = $(el)
          $target = $(target)
          rules =
            [
              [
                'gc-program-workout-item'
                'gc-program-workouts-list'
              ]
              [
                'gc-workout-exercise-item'
                'gc-workout-exercises-list'
              ]
              [
                'gc-properties-list-item'
                'gc-properties-list'
              ]
            ]
          _.any rules, (classNames) ->
            $el.hasClass(classNames[0]) and $target.hasClass(classNames[1])

      @smaug = Dragula [], options

      @smaug.on 'drop', (el, target, source, sibling) ->
        App.vent.trigger('drag_n_drop:item:dropped', arguments...)

    _initHandlers: ->
      @app.reqres.setHandlers

        'drag_n_drop:instance': =>
          @smaug