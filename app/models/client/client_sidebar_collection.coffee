Backbone = require 'backbone'

module.exports = class ClientEWPCollection extends Backbone.Collection

  url: '/api/mobile'

  setUrl: (type) =>
    @url = "#{@url}/me/#{type}"
    @type = type