define ->

  tour = null
  getFinishedSteps = ->
    return unless App.reqres.hasHandler('current_user_id')
    name = "tour_#{App.request('current_user_id')}"
    tour = JSON.parse(window.localStorage[name] || '[]') || []

  class TutorialStepsCollection extends Backbone.Collection

    comparator: (step) ->
      step.get('id')

    add: (models, options) ->
      getFinishedSteps() unless tour
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
      name = "tour_#{App.request('current_user_id')}"
      window.localStorage[name] = JSON.stringify(tour)
