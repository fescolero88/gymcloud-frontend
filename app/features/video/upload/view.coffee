define [
  './template'
], (
  template
) ->
  class UploadVideoModal extends Marionette.ItemView

    template: template

    ui:
      'uploadTrigger': '.gc-upload-trigger'
      'uploadControl': '.gc-video-upload-control'
      'uploadDetailsPanel': '.gc-video-item-upload'
      'videoFileName': '.gc-video-file-name'
      'uploadProgress': '.gc-progress'
      'uploadProgressText': '.gc-progress-text'
      'footerButton': '.gc-footer-btn'
      'uploadDropzone': '.gc-video-upload'
      'deleteVideo': '.gc-delete-video'
      'editName': '.gc-update-name'
      'uploadControls': '.gc-video-controls'

    events:
      'click @ui.uploadTrigger': 'upload'
      'click @ui.deleteVideo': 'deleteVideo'
      'click @ui.editName': 'toggleEditName'
      'blur @ui.videoFileName': 'saveVideoDetails'

    behaviors:
      stickit:
        bindings:
          '.gc-video-file-name': 'name'

    initialize: ->
      @file = {}

    onShow: ->
      @_initFileUpload()

    _initFileUpload: ->
      @ui.uploadControl.fileupload
        url: '/videos'
        dropZone: @ui.uploadDropzone
        dataType: 'json'
        add: @_onFileAdd
        done: @_videoUploaded
        progressall: @_showProgress
      
      .bind 'fileuploadsubmit', (e, data) =>
        data.formData = name: @file.name

    upload: ->
      @ui.uploadControl.click()

    processFile: (info) ->
      @model.set 'name', info.name
      @ui.uploadDetailsPanel.removeClass 'hidden'
      @ui.footerButton.text 'Finish'

    _showProgress: (e, data) =>
      progress = parseInt(data.loaded / data.total * 100, 10)
      @_updateProgress progress
      
    _videoUploaded: (e, data) =>
      @model.set data.result
      @ui.uploadControls.removeClass 'hidden'
      @ui.videoFileName.attr 'contenteditable', true

    _updateProgress: (value) =>
      @ui.uploadProgress.css 'width', "#{value}%"
      @ui.uploadProgressText.text("#{value}%")

    _onFileAdd: (_e, data) =>
      @file = data.files[0]
      if !(/\.(webm|mkv|flv|vob|mp4|m4v)$/i).test(@file.name)
        App.request 'messenger:show',
          message: 'Invalid File Type'
          type: 'info'
        return

      @processFile @file
      data.submit()
      @ui.videoFileName.attr 'contenteditable', false

    deleteVideo: ->
      @model.destroy().then =>
        @model.clear()
        @ui.uploadDetailsPanel.addClass 'hidden'
        @ui.uploadControls.addClass 'hidden'
        @_updateProgress 0
        App.request 'messenger:show',
          message: 'Video Deleted'

    toggleEditName: ->
      @ui.videoFileName.focus()

    saveVideoDetails: ->
      if @model.hasChanged('name')
        @model.save().then ->
          App.request 'messenger:show',
            type: 'success'
            message: 'filename updated'
