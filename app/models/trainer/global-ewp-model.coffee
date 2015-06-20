Backbone = require 'backbone'

module.exports = class GlobalEWPModel extends Backbone.Model

  initialize: (options) ->
    @url = "/api/mobile/#{options.type}"


