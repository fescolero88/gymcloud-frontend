Marionette = require 'backbone.marionette'

MessagesView = require '../../../views/general/messages/messages-view.coffee'

module.exports = class MessagesController extends Marionette.Controller

  initialize: (options) ->
    @main_view = options.main_view

  messages: ->
    @view = new MessagesView()
    @main_view.content.show @view
