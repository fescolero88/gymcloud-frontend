define ->

  class CustomCollection extends Backbone.Collection

    initialize: =>
      @isFetched = false
      @isRequest = false
      @on('sync', @onSync)
      @on('request', @onRequest)
      @on('error', @onError)

    onSync: ->
      @isFetched = true
      @isRequest = false

    onRequest: ->
      @isRequest = true

    onError: ->
      @isRequest = false
