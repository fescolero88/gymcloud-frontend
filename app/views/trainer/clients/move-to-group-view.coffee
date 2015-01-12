Marionette = require 'backbone.marionette'

module.exports = class MoveToGroupView extends Marionette.ItemView
  className: 'modal-dialog modal-sm'
  template: Templates.trainer.clients.move_to_group
