Marionette = require 'backbone.marionette'

module.exports = class MoveToGroupView extends Marionette.ItemView

  template: Templates.trainer.clients.move_to_group

  className: 'modal-dialog modal-sm'

  events:
    "submit .gc-move-to-group-form": "submitMovetogroupForm"

