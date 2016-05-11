define [
  './view'
], (
  WorkoutVideoAssignView
) ->

  class Module extends Marionette.Module

    initialize: ->
      @on 'start', ->
        @_initHandlers()

    _initHandlers: ->
      @app.reqres.setHandler('modal:video:assign', @_initModal)

    _initModal: (model) =>
      view = new WorkoutVideoAssignView model: model
      region = App.request('app:layouts:base').getRegion('modal')
      region.show(view)
      region.$el.modal('show')

      @listenToOnce view, 'modal:closed', ->
        region.$el.modal('hide')
        region.destroy()
