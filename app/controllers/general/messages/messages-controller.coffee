Marionette = require 'backbone.marionette'

MessagesView = require '../../../views/general/messages/messages-view.coffee'

module.exports = class MessagesController extends Marionette.Controller

  initialize: (options) ->
    @mainView = options.mainView

  messages: ->
    @view = new MessagesView()
    @mainView.content.show @view
