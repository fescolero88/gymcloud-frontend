define [
  'backbone'
  'models/folder'
], (
  Backbone
  Folder
)->

  class Library extends Backbone.Collection

    model: Folder

    url: ->
      uid = App.request('current_user_id')
      "/users/#{uid}/collections/library"