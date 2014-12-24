Marionette = require 'backbone.marionette'

module.exports = class MessagesView extends Marionette.ItemView

  initialize: =>
    @template = require '../../../templates/general/messages/messages'
