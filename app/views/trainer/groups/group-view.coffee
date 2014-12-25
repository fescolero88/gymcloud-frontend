Marionette = require 'backbone.marionette'
myTemplate = require '../../../templates/trainer/groups/group'

module.exports = class GroupView extends Marionette.LayoutView
  template: myTemplate
