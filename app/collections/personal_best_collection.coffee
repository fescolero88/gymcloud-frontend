define [
  'backbone'
  'models/trainer/personal-best-model'
], (
  Backbone
  PersonalBestModel
) ->

  class PersonalBestCollection extends Backbone.Collection

    urlRoot: '/api/mobile'

    model: PersonalBestModel
