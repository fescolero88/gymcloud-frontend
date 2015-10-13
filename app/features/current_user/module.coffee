define [
  './model'
  './preload'
], (
  CurrentUser
  preload
) ->

  class Module extends Marionette.Module

    initialize: ->

      @on 'start', ->
        @_initTokenHandlers()
        @_initUserHandlers()
        @app.request('current_user:reset')

    _initTokenHandlers: ->

      @app.reqres.setHandlers

        'auth:isAuthorized': =>
          !!@app.request('accessToken:get')

        'auth:isAuthorizedAs': (permission) =>
          return false unless @app.request('auth:isAuthorized')
          user = @app.request('current_user')
          isPro = user.get('is_pro')

          permission is 'trainer' and isPro ||
          permission is 'client' and !isPro

        'accessToken:set': (token) ->
          window.localStorage.setItem('accessToken', token)

        'accessToken:get': ->
          window.localStorage.getItem('accessToken')

        'accessToken:remove': ->
          window.localStorage.removeItem('accessToken')

        'auth:onSuccess': (data) =>
          @app.request('accessToken:set', data.access_token)
          @app.request('current_user').fetch()
            .then =>
              @app.request('current_user:init:collections')
                .then =>
                  window.location.replace '#'

    _initUserHandlers: ->
      @app.reqres.setHandlers

        'current_user:reset': =>
          @app.data.current_user = new CurrentUser

        'current_user': =>
          @app.data.current_user

        'current_user_id': =>
          @app.request('current_user').get('id')

        'data:profile': =>
          @app.request('current_user')

        'current_user:init:user': @_initUser

        'current_user:init:collections': @_initUserCollections

    _initUser: =>
      defer = new $.Deferred
      if @app.request('accessToken:get')
        @app.request('current_user').fetch()
          .success(defer.resolve)
          .fail(defer.reject)
      else
        defer.reject()
      defer.fail =>
        @app.request('accessToken:remove')
      defer.promise()

    _initUserCollections: =>
      defer = new $.Deferred
      user = @app.request('current_user')
      dfds = preload(user)
      $.when(dfds...).then(defer.resolve)
      defer.promise()
