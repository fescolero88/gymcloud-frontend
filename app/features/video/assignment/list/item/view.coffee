define [
  'moment'
  'collections/videos_list'
  './template'
  'features/video_library/list/item/template'
], (
  moment
  VideosCollection
  template
  VideoLibraryTemplate
)->
  class AssignVideoItemView extends Marionette.ItemView

    getTemplate: ->
      if @options.set_template?
        VideoLibraryTemplate
      else
        template

    className: 'col-xs-4 gc-video-thumb'

    ui:
      assignVideo: '.gc-assign-video'
      remove: '.gc-icon-trash'

    events:
      'click @ui.remove': 'removeModel'

    triggers:
      'click @ui.assignVideo': 'assign'

    behaviors:
      video_features: true

      stickit:
        bindings:
          '.gc-video-title':
            observe: 'nameFormatted'
            updateModel: false
          '.gc-video-icon':
            observe: 'filter'
            update: ($el, val, model, options) ->
              $el.addClass "gc-video-#{model.get('filter')}-icon"
          '.gc-video-preview':
            observe: 'preview_picture_url'
            update: ($el, val, model, options) ->
              $el.css 'background-image', "url(#{val})"
          '.gc-video-uploaded-at':
            observe: 'uploaded_at'
            onGet: (date) ->
              moment(date).format 'Do of MMM'

    templateHelpers: =>
      isAssigned: @options.isAssigned

    removeModel: ->
      @model.collection = new VideosCollection
      App.request('modal:confirm:delete', @model)
