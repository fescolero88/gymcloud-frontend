define ->

  saveShowedStep = (uid) ->
    storage = JSON.parse(window.localStorage.tour || '[]') || []
    storage.push(uid) unless _.include(storage, uid)
    window.localStorage.tour = JSON.stringify(storage)

  class TutorialStepsCollection extends Backbone.Collection

    comparator: (step) ->
      step.get('id')

    getStep: (i) ->
      step = @get(i)
      return null unless step
      uid = step.get('uniq_id')
      saveShowedStep(uid)
      step.toJSON()
