define [
  'features/stats/collection'
  'features/stats/view'
], (
  StatsCollection
  StatsCompositeView
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'welcome' : 'stats'

  class Controller extends Marionette.Controller

    stats: ->
      user = App.request('current_user')
      collection = new StatsCollection
      collection.build(user)
      view = new StatsCompositeView
        collection: collection
      @_showView(view)

    _showView: (view) ->
      App.request('views:show', view)

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
