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
      iframe: 'iframe'
      player: '.gc-video-content'
      placeholder: '.gc-exercises-exercise-video-placeholder'

    events:
      'keyup @ui.exerciseDescription': '_descriptionAutoHeight'
      'click @ui.addVideoButton': '_openUploadPopup'
      'click .gc-exercise-video-update': '_openUploadPopup'
      'click .gc-exercise-video-delete': '_deleteVideo'

    behaviors:
      video_assign: true
      stickit:
        bindings:
          '.gc-exercise-description-editor':
            observe: 'description'
            events: ['blur']

    modelEvents:
      'change:description': '_saveDescription'
      'change:video_url': '_togglePlayer'

    templateHelpers: =>
      # TODO: Render author as view
      authorAvatar: @model.get('author')?.user_profile?.avatar?.thumb?.url
      isAuthor: @_isAuthor()
      isMine: @_isMine()
      videoType: @_getVideoType()

    initialize: (data) =>
      @oldDescription = @model.get('description')
      @privacyButtonsView = new PrivacyButtonsView(model: @model)

    onShow: ->
      @getRegion('privacyButtons').show(@privacyButtonsView) if @_isAuthor()

    _descriptionAutoHeight: ->
      exerciseDesc = @ui.exerciseDescription.get 0
      if exerciseDesc.scrollHeight > exerciseDesc.clientHeight
        exerciseDesc.style.height = "#{exerciseDesc.scrollHeight}px"

    _isAuthor: ->
      @model.get('author_id') == App.request('current_user_id')

    _isMine: ->
      @model.get('user_id') == App.request('current_user_id')

    _saveDescription: ->
      description = @model.get('description')
      if @model.hasChanged('description') && description != @oldDescription
        @model.save()
          .then =>
            @oldDescription = @model.get('description')
          .fail (_xhr, _textStatus, _errorThrown) =>
            @model.set(description: @oldDescription)

    _openUploadPopup: ->
      view = App.request('base:uploadVideo')
      @listenToOnce(view, 'videoUploaded', @assignVideo)

    _togglePlayer: ->
      if @model.get('video_url')
        @ui.player.removeClass('hidden')
        @ui.placeholder.addClass('hidden')
        @ui.iframe.attr('src', @model.get('video_url'))
      else
        @ui.player.addClass('hidden')
        @ui.placeholder.removeClass('hidden')

    assignVideo: (model) ->
      @trigger('assignVideo', model)

    _deleteVideo: ->
      App.request 'base:confirmationalModal',
        title: 'Remove exercise video?'
        content: 'Are you sure you want to remove this video from exercise?'
        confirmBtn: 'Remove'
        confirmCallBack: =>
          @model.save({video_url: null, video_id: null}, wait: true)

    _getVideoType: ->
      url = @model.get('video_url')
      return unless _.any(url)
      url.indexOf('vimeo') isnt -1 && 'vimeo' || 'youtube'
