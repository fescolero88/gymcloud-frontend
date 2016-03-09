define [
  'features/new_profile_view/view'
  'pages/users/overview/page'
], (
  NewProfileView
  OverviewPage
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'users/me(/)': 'myProfile'
      'users/me/edit': 'editMyProfile'
      'users/:id': 'root'
      'users/:id/:state': 'overview'

  class Controller extends Marionette.Controller


    root: (id) ->
      path = "users/#{id}/programs"
      App.vent.trigger('redirect:to', path)

    overview: (id, state) ->
      new OverviewPage
        id: id
        state: state

    myProfile: ->
      user = App.request('current_user')
      @root(user.id)

    editMyProfile: ->
      user = App.request('current_user')
      view = new NewProfileView
        model: user.user_profile
      @_showView(view)

    _showView: (view) ->
      App.request('views:show', view)

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
