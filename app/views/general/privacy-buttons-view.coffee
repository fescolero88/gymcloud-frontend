Marionette = require 'backbone.marionette'

module.exports = class PrivacyButtonsView extends Marionette.ItemView

  template: Templates.general.privacy_buttons

  className: 'gc-exercise-privates'

  ui:
    publicGroup: '.btn-group'
    publicRadio: 'input[name=public]'

  events:
    'change @ui.publicRadio': 'setPrivacy'

  initialize: (data) =>
    @isPublic = data.isPublic

  templateHelpers: ->
    isPublic: @isPublic
    isPrivate: not @isPublic

  setPrivacy: =>
    @isPublic = @ui.publicGroup.find(':checked').val() == 'true'
    @trigger 'privacy:changed', @isPublic
