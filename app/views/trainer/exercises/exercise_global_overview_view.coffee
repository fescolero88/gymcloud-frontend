Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

PrivacyButtonsView = require 'views/general/privacy-buttons-view'

module.exports = class ExerciseGlobalOverviewView extends Marionette.LayoutView
  template: Templates.trainer.exercises.exercise_global_overview
  className: 'gc-exercises-exercise-view'

  regions:
    privacyButtons: '#gc-privacy-button-region'

  initialize: (data) =>
    @privacyButtonsView = new PrivacyButtonsView
      isPublic: @model.get('is_public')
    @listenTo @privacyButtonsView, 'privacy:changed', @setPrivacy

  onShow: =>
    @privacyButtons.show @privacyButtonsView

  setPrivacy: (isPublic) =>
    @model.set 'is_public', isPublic
    @trigger 'privacy:changed', @model.get 'is_public'
    $.ajax
      url: @model.url
      method: 'PUT'
      dataType: 'json'
      data: JSON.stringify @model
      success: (data) =>
        App.request 'messenger:show',
          hideAfter: 5
          message: "Privacy settings was changed"
          type: 'info'

