Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

PrivacyButtonsView = require 'views/general/privacy-buttons-view'

module.exports = class ExerciseGlobalOverviewView extends Marionette.LayoutView

  template: require('templates/trainer/exercises/exercise_global_overview')

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
    'keydown @ui.exerciseTitle': 'onTitleEditing'
    'blur @ui.exerciseDescription': 'saveDescription'
    'keyup @ui.exerciseDescription': 'exerciseDescriptionAutoHeight'

  modelEvents:
    sync: 'onSync'

  initialize: (data) =>
    @privacyButtonsView = new PrivacyButtonsView
      isPublic: @model.get('is_public')
    @listenTo @privacyButtonsView, 'privacy:changed', @setPrivacy
    profile = App.request 'data:profile'
    if profile.get('id') is @model.get('author').id
      @myItem = true

    @updatedAttribute = '' #used for showing proper alert message of what gets modified

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
    @model.save()
    @updatedAttribute = 'privacy'
    
  onSync:(model, response, options) ->
    if @updatedAttribute is 'privacy'
      @trigger 'privacy:changed', @model.get 'is_public'
      App.request 'messenger:show',
        message: "Privacy settings was changed"
    else
      App.vent.trigger 'spinner:global:start'
      App.request('data:reload', 'exercises', App.request 'data:exercises:root').then =>
        App.vent.trigger 'spinner:global:stop'
        App.request 'messenger:show',
        hideAfter: 5
        message: "Exercise Updated."
        type: 'success'

  editExercise: =>
    @trigger 'exercise:edit'

  saveExerciseTitle: (event) ->
    @model.set 'name', @ui.exerciseTitle.text()

    if @model.hasChanged()
      @model.save()
      @updatedAttribute = 'title'

  saveDescription: ->
    @model.set 'description', @ui.exerciseDescription.val()

    if @model.hasChanged()
      @model.save()

  exerciseDescriptionAutoHeight: =>
    exerciseDesc = @ui.exerciseDescription.get 0
    if exerciseDesc.scrollHeight > exerciseDesc.clientHeight
      exerciseDesc.style.height = "#{exerciseDesc.scrollHeight}px"

  onTitleEditing: (event) ->
    if event.keyCode == 13
      false