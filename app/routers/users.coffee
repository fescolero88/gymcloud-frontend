define [
  'features/new_profile_view/view'
  'pages/users/overview/page'
  'models/user'
], (
  NewProfileView
  OverviewPage
  UserModel
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'users/me(/)': 'myProfile'
      'users/me/edit': 'editMyProfile'
      'users/:id': 'root'
      'users/:id/edit': 'editUserProfile'
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
      @_editUserProfile(user.user_profile)

    editUserProfile: (id) ->
      currentUser = App.request('current_user')
      user = currentUser.clients.get(id)
      user ||= new UserModel(id: id)
      return @_editUserProfile(user.user_profile) unless user.isNew()
      user.fetch()
        .then -> @_editUserProfile(user.user_profile)

    _editUserProfile: (profile) ->
      view = new NewProfileView
        model: profile
      @_showView(view)

    _showView: (view) ->
      App.request('views:show', view)

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
