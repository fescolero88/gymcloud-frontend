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
    exerciseTitle: '.gc-exercise-title > span'
    exerciseDescription: '.gc-exercise-description-editor'

  events:
    'click @ui.editExerciseButton': 'editExercise'
    'blur @ui.exerciseTitle': 'saveExerciseTitle'
    'blur @ui.exerciseDescription': 'saveDescription'
    'keyup @ui.exerciseDescription': 'exerciseDescriptionAutoHeight'

  initialize: (data) =>
    @privacyButtonsView = new PrivacyButtonsView
      isPublic: @model.get('is_public')
    @listenTo @privacyButtonsView, 'privacy:changed', @setPrivacy
    @listenTo @model, 'sync', @exerciseTitleSaved
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

  saveExerciseTitle: (event) ->
    @model.set 'name', @ui.exerciseTitle.text()

    if @model.hasChanged()
      @model.save()

  exerciseTitleSaved: ->
    App.vent.trigger 'spinner:global:start'
    App.request('data:reload', 'exercises', App.request 'data:exercises:root').then =>
      App.vent.trigger 'spinner:global:stop'
      App.request 'messenger:show',
      hideAfter: 5
      message: "Exercise Updated."
      type: 'success'

  saveDescription: ->
    @model.set 'description', @ui.exerciseDescription.val()

    if @model.hasChanged()
      @model.save()

  exerciseDescriptionAutoHeight: =>
    exerciseDesc = @ui.exerciseDescription.get 0
    if exerciseDesc.scrollHeight > exerciseDesc.clientHeight
      exerciseDesc.style.height = "#{exerciseDesc.scrollHeight}px"
