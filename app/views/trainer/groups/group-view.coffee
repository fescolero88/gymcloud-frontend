Marionette = require 'backbone.marionette'

module.exports = class GroupView extends Marionette.LayoutView
  template: require '../../../templates/trainer/groups/group'
