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

  templateHelpers: =>
    video_url = @model.get 'video_url'
    if video_url
      video_id = video_url.split('v=')[1]
      ampIndex = video_id.indexOf '&'
      if ampIndex != -1
        video_id = video_id.substring 0, ampIndex
      video_url = "https://youtube.com/v/#{video_id}"

    return {
      video_url: video_url
    }

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

