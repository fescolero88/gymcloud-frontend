define ->

  class EnterResultsForNewWorkoutEvent extends Marionette.Behavior

    key: 'enter_results_for_new_workout_event'

    onShow: ->
      _.bind(@view.delegateEvents, @view)
        "click #{@options.el}": _.bind(@_createWorkoutEvent, @)

    _createWorkoutEvent: ->
      event = new Backbone.Model
        personal_workout_id: _.result(@options, 'personal_workout_id')
        begins_at: moment().format()
        ends_at: moment().add(1, 'hour').format()

      event.urlRoot = '/workout_events'
      event
        .save()
        .then ->
          path = "#/events/#{event.id}/results"
          App.vent.trigger('redirect:to', path)
