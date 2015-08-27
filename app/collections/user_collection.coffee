define [
  'backbone'
], (
  Backbone
) ->

  class UserCollection extends Backbone.Collection

    initialize: (models, options) ->
      @userId = options.user?.id || App.request("data:profile").id
      @type = options.type

    url: ->
      "/users/#{@userId}/collections/#{@type}"

    # TODO: implement all models for user collections
    # model: ->
    #   modelName = _.singularize(@type)
    #   require("models/#{modelName}")
