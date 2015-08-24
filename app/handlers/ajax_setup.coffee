define ->
  loadingCount = 0
  (App, config) ->
    $(document).ajaxStart () ->
      App.vent.trigger('spinner:start') if ++loadingCount is 1

    $(document).ajaxComplete () ->
      if loadingCount > 0 && --loadingCount is 0
        App.vent.trigger('')

    $(document).ajaxError (event, jqxhr, settings, thrownError) ->
      if jqxhr.status is 401 && '/login' != Backbone.history.fragment
        Backbone.history.navigate('/login')

      if jqxhr.status is 403
        error = jqxhr.responseJSON.error
        error = error.join(', ') if _.isArray(error)
        message = error.replace( /\s+(\[.+\])/, "")
        App.request 'messenger:show',
          hideAfter: 5
          message: message
          type: 'error'

    $.ajaxSetup
      headers: {'X-Requested-With': 'XMLHttpRequest'}
      contentType: 'application/json'
      beforeSend: (xhr, options) ->
        options.url = "#{config.api.url}#{options.url}"
        accessToken = App.request('accessToken:get')
        if accessToken
          authorization = "Bearer #{accessToken}"
          xhr.setRequestHeader('Authorization', authorization)
        return