define [
  'features/tutorial/collection'
  'features/tutorial/template'
  'bootstrap-tour'
], (
  TutorialStepsCollection
  template
) ->

  class Module extends Marionette.Module

    initialize: ->
      tour = @_initTour()
      App.reqres.setHandler('tour', -> tour)

    _getTourClass: ->
      window.Tour::addStep = (step) ->
        @collection.add(step) if step
        @

      window.Tour::getStep = (i) ->
        step = @collection.getStep(i)
        return if step is null
        $.extend({
          id: 'step-' + i
          path: ''
          host: ''
          placement: 'auto'
          title: ''
          content: '<p></p>'
          next: if i == @_options.steps.length - 1 then -1 else i + 1
          prev: i - 1
          animation: true
          container: @_options.container
          autoscroll: @_options.autoscroll
          backdrop: @_options.backdrop
          backdropContainer: @_options.backdropContainer
          backdropPadding: @_options.backdropPadding
          redirect: @_options.redirect
          reflexElement: step.element
          orphan: @_options.orphan
          duration: @_options.duration
          delay: @_options.delay
          template: @_options.template
          onShow: @_options.onShow
          onShown: @_options.onShown
          onHide: @_options.onHide
          onHidden: @_options.onHidden
          onNext: @_options.onNext
          onPrev: @_options.onPrev
          onPause: @_options.onPause
          onResume: @_options.onResume
          onRedirectError: @_options.onRedirectError
        }, step)

      TourClass = window.Tour
      delete window.Tour
      TourClass

    _getTourInstance: ->
      TourClass = @_getTourClass()
      new TourClass
        storage: false
        name: 'tour'
        steps: []
        smartPlacement: true
        backdrop: false
        backdropContainer: 'body'
        backdropPadding: 0
        onShown: (tour) -> tour.collection.saveShowedStep(tour._current)
        template: (i, step) -> template(step)

    _initTour: ->
      tour = @_getTourInstance()
      tour.collection = new TutorialStepsCollection

      delete tour._options.steps
      tour._options.__defineGetter__('steps', -> tour.collection.toJSON())

      tour.init()
      tour
