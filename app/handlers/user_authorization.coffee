define ->
  (App) ->
    App.reqres.setHandlers

      'auth:isAuthorized': ->
        !!App.request('accessToken:get')

      'auth:isAuthorizedAs': (permission) ->
        return false unless App.request('auth:isAuthorized')
        isPro = App.data.profileModel.get('is_pro')

        permission is 'trainer' and isPro ||
        permission is 'client' and !isPro


      'accessToken:set': (token) ->
        window.localStorage.setItem 'accessToken', token

      'accessToken:get': ->
        window.localStorage.getItem 'accessToken'

      'accessToken:remove': ->
        window.localStorage.removeItem 'accessToken'