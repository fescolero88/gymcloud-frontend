define [
  'backbone'
], (
  Backbone
) ->

  class GlobalWorkout extends Backbone.Model

    urlRoot: '/api/mobile/workouts/'
