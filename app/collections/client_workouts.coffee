define [
  'backbone'
], (
  Backbone
) ->

  class ClientWorkouts extends Backbone.Collection

    url: '/api/mobile/me/workouts'
