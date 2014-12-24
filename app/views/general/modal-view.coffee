Marionette = require 'backbone.marionette'

module.exports = class ModalView extends Marionette.ItemView

  initialize: =>
    @template = require '../../templates/general/modals'
