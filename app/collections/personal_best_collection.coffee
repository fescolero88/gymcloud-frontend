define [
  'models/personal_best'
], (
  PersonalBestModel
) ->

  class PersonalBestCollection extends Backbone.Collection

    urlRoot: '/api/mobile'

    model: PersonalBestModel
