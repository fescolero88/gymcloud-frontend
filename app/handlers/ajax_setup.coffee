define ->

  (App, config) ->

    $(document).ajaxError (event, jqxhr, settings, thrownError) ->
      if jqxhr.status is 401 && '/login' != Backbone.history.fragment
        Backbone.history.navigate('/login')

      if jqxhr.status is 403
        error = jqxhr.responseJSON.error
        error = error.join(', ') if _.isArray(error)
        message = error.replace( /\s+(\[.+\])/, "")
        App.request 'messenger:show',
          message: message
          type: 'error'

    Backbone.originalSync = Backbone.sync
    Backbone.sync = (method, model, options) ->
      options.type = 'PATCH' if method == 'update'
      Backbone.originalSync method, model, options

    $.ajaxSetup
      headers: {'X-Requested-With': 'XMLHttpRequest'}
      contentType: 'application/json'
      crossDomain: true
      xhrFields: withCredentials: true
      beforeSend: (xhr, options) ->
        xhr.withCredentials = true
        options.url = "#{config.api.url}#{options.url}"
        accessToken = App.request('accessToken:get')
        if accessToken
          authorization = "Bearer #{accessToken}"
          xhr.setRequestHeader('Authorization', authorization)
        return
