define [
  'features/privacy_buttons/view'
  './template'
], (
  PrivacyButtonsView
  template
) ->
  class ExerciseOverviewView extends Marionette.LayoutView

    template: template

    className: 'gc-exercises-exercise-view'

    regions:
      privacyButtons: 'region[data-name="privacy-buttons"]'

    ui:
      exerciseDescription: '.gc-exercise-description-editor'
      addVideoButton: '.gc-add-video'

    events:
      'keyup @ui.exerciseDescription': '_descriptionAutoHeight'
      'click @ui.addVideoButton': 'addVideo'

    behaviors:

      stickit:
        bindings:
          '.gc-exercise-description-editor':
            observe: 'description'
            events: ['blur']

    modelEvents:
      'change:description': '_saveDescription'

    templateHelpers: =>
      videoUrl = @model.get('video_url') || ''
      videoUrlSplitted = videoUrl.split 'v='
      if videoUrlSplitted.length > 1
        videoId = videoUrlSplitted[1]
        ampIndex = videoId.indexOf '&'
        if ampIndex != -1
          videoId = video_id.substring 0, ampIndex
        videoUrl = "https://youtube.com/v/#{videoId}"

      isAuthor: @_isAuthor()

    initialize: (data) =>
      @oldDescription = @model.get('description')
      @privacyButtonsView = new PrivacyButtonsView(model: @model)

    onShow: ->
      @privacyButtons.show(@privacyButtonsView) if @_isAuthor()

    _descriptionAutoHeight: ->
      exerciseDesc = @ui.exerciseDescription.get 0
      if exerciseDesc.scrollHeight > exerciseDesc.clientHeight
        exerciseDesc.style.height = "#{exerciseDesc.scrollHeight}px"

    _isAuthor: ->
      @model.get('author_id') == App.request('current_user_id')

    _saveDescription: ->
      description = @model.get('description')
      if @model.hasChanged('description') && description != @oldDescription
        @model.save()
          .then =>
            @oldDescription = @model.get('description')
          .fail (_xhr, _textStatus, _errorThrown) =>
            @model.set(description: @oldDescription)

    addVideo: ->
      App.request 'base:uploadVideo'
