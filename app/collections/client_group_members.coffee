define [
  'backbone'
], (
  Backbone
) ->

  class ClientGroupMembers extends Backbone.Collection

    urlRoot: '/api/mobile/client_groups'
