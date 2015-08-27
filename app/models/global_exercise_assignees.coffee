define [
  'backbone'
], (
  Backbone
) ->

  class AssigneesList extends Backbone.Model

    urlRoot: '/api/mobile/exercises'
