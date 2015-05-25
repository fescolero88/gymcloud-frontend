Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

PrivacyButtonsView = require 'views/general/privacy-buttons-view'

module.exports = class ExerciseGlobalOverviewView extends Marionette.LayoutView

  template: Templates.trainer.exercises.exercise_global_overview

  className: 'gc-exercises-exercise-view'

  regions:
    privacyButtons: '#gc-privacy-button-region'

  ui:
    editExerciseButton: '.gc-exercise-edit-button'

  events:
    'click @ui.editExerciseButton': 'editExercise'

  initialize: (data) =>
    @privacyButtonsView = new PrivacyButtonsView
      isPublic: @model.get('is_public')
    @listenTo @privacyButtonsView, 'privacy:changed', @setPrivacy
    profile = App.request 'data:profile'
    if profile.get('id') is @model.get('author').id
      @myItem = true

  templateHelpers: =>
    videoUrl = @model.get('video_url') || ''
    videoUrlSplitted = videoUrl.split 'v='
    if videoUrlSplitted.length > 1
      videoId = videoUrlSplitted[1]
      ampIndex = videoId.indexOf '&'
      if ampIndex != -1
        videoId = video_id.substring 0, ampIndex
      videoUrl = "https://youtube.com/v/#{videoId}"

    return {
      video_url: videoUrl
    }

  onShow: =>
    if @myItem
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

  editExercise: =>
    @trigger 'exercise:edit'
