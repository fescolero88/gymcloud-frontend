define [
  'pages/payments/overview/page'
], (
  PaymentsOverviewPage
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'payments(/)': 'root'
      'payments/:state': 'overview'

  class Controller extends Marionette.Controller

    root: ->
      path = 'payments/transactions'
      App.vent.trigger('redirect:to', path)

    overview: (state) ->
      new PaymentsOverviewPage
        state: state

    _showView: (view) ->
      App.request('views:show', view)

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
