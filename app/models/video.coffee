define ->

  class VideoModel extends Backbone.Model

    type: 'Video'

    defaults:
      preview: undefined
      duration: undefined
      filter: undefined
      title: undefined
      is_assigned: undefined

    initialize: ->
      @computedFields = new Backbone.ComputedFields(@)

    computed: ->
      nameFormatted:
        depends: ['name']
        get: (attrs) =>
          @_stripExtention(attrs.name)

    _stripExtention: (name) ->
      re = /\.(webm|mkv|flv|vob|mp4|m4v|avi|mpeg|mpg|3gp|mov)$/i
      name.replace(re, '')
