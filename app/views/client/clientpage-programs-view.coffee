Marionette = require 'backbone.marionette'
myTemplate = require '../../templates/client/programs'

module.exports = class ProgramsView extends Marionette.ItemView
  template: myTemplate
