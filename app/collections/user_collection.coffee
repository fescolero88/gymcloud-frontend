module.exports = Backbone.Collection.extend

  initialize: (models, options) ->
    @userId = options.user?.id || App.request("data:profile").id
    @type = options.type

  url: ->
    "/users/#{@userId}/collections/#{@type}"

  # model: ->
  #   modelName = _.singularize(@type)
  #   require("models/#{modelName}")