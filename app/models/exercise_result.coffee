define [
  'moment'
], (
  moment
) ->

  class ExerciseResult extends Backbone.Model

    type: 'ExerciseResult'

    urlRoot: '/exercise_results'

    computed:
      name:
        depends: ['created_at']
        get: ([created_at]) ->
          moment(created_at).format('DD MMMM, YYYY')
        toJSON: false

    initialize: ->
      @computedFields = new Backbone.ComputedFields(@)
