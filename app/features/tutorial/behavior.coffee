define ->

  class TutorialBehavior extends Marionette.Behavior

    key: 'tutorial'

    initialize: ->
      @tour = App.request('tour')

    onShow: ->
      return unless feature.isEnabled('tooltips_tour')

      @steps = if _.isFunction(@options.steps)
        @options.steps(@view)
      else
        @options.steps

      return if @tour.collection.isEmpty() and !@steps.length
      @tour.addSteps(@steps)

      return unless @options.main
      @tour.restart() unless @tour.collection.isEmpty()

    onBeforeDestroy: ->
      return unless @options.main
      if !@tour.ended() and !@tour.collection.isEmpty()
        @tour.end()
        @tour.collection.reset()
