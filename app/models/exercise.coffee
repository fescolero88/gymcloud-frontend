define [
  'backbone'
], (
  Backbone
) ->

  class Exercise extends Backbone.Model

    type: 'Exercise'

    urlRoot: '/exercises/'

    validation:
      name:
        required: true

    initialize: (_options) ->
      @__defineGetter__ 'parent', @_getFolder
      @__defineGetter__ 'folder', @_getFolder

    _getFolder: ->
      user = App.request('current_user')
      collection = user.folders
      collection?.get(@get('folder_id'))
