Marionette = require 'backbone.marionette'
LibraryPresetController = require 'controllers/general/library-preset-controller'

module.exports = class LibraryPresetRouter extends Marionette.AppRouter

  controller: LibraryPresetController

  appRoutes:
    'library-preset(/)': 'loadPreset'
