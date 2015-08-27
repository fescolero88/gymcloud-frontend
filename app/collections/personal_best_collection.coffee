define [
  'backbone'
  'models/personal_best'
], (
  Backbone
  PersonalBestModel
) ->

  class PersonalBestCollection extends Backbone.Collection

    urlRoot: '/api/mobile'

    model: PersonalBestModel
