define [
  'features/profile/view'
  'features/new_profile_view/view'
], (
  ProfileView
  NewProfileView
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'tr/me(/)': 'profile'
      'users/me(/)': 'myProfile'
      'users/:id(/)': 'profile'
      'users/me/edit': 'editMyProfile'

  class Controller extends Marionette.Controller

    profile: (id) ->
      user = App.request('current_user')
      user = user.clients.get(id)
      if user
        @_userProfile(user)
      else
        user = new User(id: id)
        user.fetch()
          .then =>
            @_userProfile(user)

    myProfile: ->
      user = App.request('current_user')
      @_userProfile(user)

    editMyProfile: ->
      user = App.request('current_user')
      view = new NewProfileView
        model: user.profile
      @_showView(view)

    _userProfile: (user) ->
      view = new ProfileView
        model: user
      @_showView(view)

    _showView: (view) ->
      App.request('views:show', view)

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
