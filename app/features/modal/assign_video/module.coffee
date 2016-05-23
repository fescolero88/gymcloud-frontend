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
      @listenTo(@app.vent, 'modal:video:close', @_closeModal)

    _initModal: (model) =>
      view = new WorkoutVideoAssignView
        model: model
        type: 'modal'
      @region = App.request('app:layouts:base').getRegion('modal')
      @region.show(view)
      @region.$el.modal('show')

    _closeModal: ->
      @region.$el.modal('hide')
      @region.destroy()
