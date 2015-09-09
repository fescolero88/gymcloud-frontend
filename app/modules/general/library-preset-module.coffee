LibraryPresetRouter = require 'routers/general/library-preset-router'

module.exports = class LibraryPresetModule extends Marionette.Module

  initialize: ->
    @on 'start', ->
      new LibraryPresetRouter
