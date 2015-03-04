Marionette = require 'backbone.marionette'

module.exports = class ProgramsView extends Marionette.ItemView

  template: Templates.client.programs

  collectionEvents:
    sync: 'render'
