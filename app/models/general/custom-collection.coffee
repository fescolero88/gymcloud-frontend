Backbone = require 'backbone'

module.exports = class CustomCollection extends Backbone.Collection

  isFetched: false
  isRequest: false

  initialize: =>
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
