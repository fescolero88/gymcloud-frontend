Backbone = require 'backbone'

module.exports = class SearchResultsCollection extends Backbone.Collection
  url: '/api/mobile/search'
