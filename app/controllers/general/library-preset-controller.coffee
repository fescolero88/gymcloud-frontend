Marionette = require 'backbone.marionette'

LibraryPresetModal = require 'views/general/modal-library-preset-view'

module.exports = class LibraryPresetController extends Marionette.Controller

  initialize: (options) ->
    @mainView = options.mainView

  loadPreset: ->
    $('region.gc-modal-preset-container').modal 'show'
