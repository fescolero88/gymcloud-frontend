Marionette = require 'backbone.marionette'
myTemplate = require '../../../templates/general/messages/messages'

module.exports = class MessagesView extends Marionette.ItemView

  initialize: =>
    @template = myTemplate
