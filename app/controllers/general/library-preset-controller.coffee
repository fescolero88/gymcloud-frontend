Marionette = require 'backbone.marionette'

LibraryPresetModal = require 'views/general/modal-library-preset-view'

module.exports =

  loadPreset: ->
    view = new LibraryPresetModal
    App.baseView.baseModalRegion.show(view)
    App.baseView.baseModalRegion.$el.modal('show')
