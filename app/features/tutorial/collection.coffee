define ->

  tour = JSON.parse(window.localStorage.tour || '[]') || []

  class TutorialStepsCollection extends Backbone.Collection

    comparator: (step) ->
      step.get('id')

    add: (models, options) ->
      steps = if _.isArray(models) then models else [models]
      models = _.filter(steps, (s) -> s and !_.include(tour, s?.uniq_id))
      super

    getStep: (i) ->
      step = @at(i)
      step?.toJSON()

    saveShowedStep: (i) ->
      step = @at(i)
      return null unless step
      uid = step.get('uniq_id')
      tour.push(uid) unless _.include(tour, uid)
      window.localStorage.tour = JSON.stringify(tour)
