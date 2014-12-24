Marionette = require 'backbone.marionette'

module.exports = class ProgramsView extends Marionette.ItemView
  template: require '../../templates/client/programs'
