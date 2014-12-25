Marionette = require 'backbone.marionette'
myTemplate = require '../../templates/general/modals'

module.exports = class ModalView extends Marionette.ItemView

  initialize: =>
    @template = myTemplate
