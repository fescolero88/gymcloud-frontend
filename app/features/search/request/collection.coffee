define [
  'backbone'
], (
  Backbone
) ->

  class Collection extends Backbone.Collection

    url: '/search'
