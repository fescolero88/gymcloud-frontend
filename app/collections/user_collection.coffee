define [
  'backbone'
], (
  Backbone
)->

  class UserCollection extends Backbone.Collection

    initialize: (models, options) ->
      @uid = options.user?.id || App.request('current_user_id')
      @type = options.type

    url: ->
      "/users/#{@uid}/collections/#{@type}"

    # TODO: implement all models for user collections
    # model: ->
    #   modelName = _.singularize(@type)
    #   require("models/#{modelName}")