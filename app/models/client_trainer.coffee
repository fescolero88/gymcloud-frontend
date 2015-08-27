define [
  'backbone'
], (
  Backbone
) ->

  class ClientTrainer extends Backbone.Model

    urlRoot: '/api/mobile/clients'

    parse: (data) ->
      data.trainer
