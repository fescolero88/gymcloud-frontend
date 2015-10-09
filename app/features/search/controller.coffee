define [
  './results/view'
  'views/general/main-view'
  'features/sidebar/view'
], (
  SearchResultsView
  MainView
  SideBarView
) ->

  class Controller extends Marionette.Controller

    search: (q, entityType = 'all', searchScope = 'all') ->
      collection = App.request('search:request:collection')
      model = App.request('search:request:model')
      model.set
        q: q
        entity_type: entityType
        search_scope: searchScope
      view = new SearchResultsView
        collection: collection
        model: model

      appRegion = App.request('app:views:base').getRegion('appRegion')

      ###
      # initialize main view and sidebar
      ###
      if !appRegion.currentView
        mainView = new MainView()
        appRegion.show mainView
        App.vent.trigger('app:view:main:render', mainView)
        appRegion.currentView = mainView
        sidebarView = new SideBarView()
        appRegion.currentView.menu.show sidebarView

      region = appRegion.currentView.getRegion('content')
      region.show(view)
