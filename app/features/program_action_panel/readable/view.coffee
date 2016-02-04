define [
  './template'
  '../model'
], (
  template
  DataModel
) ->

  class View extends Marionette.LayoutView

    template: template

    className: 'program-action-panel row'

    behaviors:

      stickit:
        model: -> @data
        bindings: ->
          highlight = ($el) ->
            $el.addClass('highlight')
            setTimeout (-> $el.removeClass('highlight')), 350

          '.counter.weeks':
            observe: 'weeksCount'
            afterUpdate: highlight
          '.counter.workouts':
            observe: 'workoutsCount'
            afterUpdate: highlight

    initialize: ->
      @data = new DataModel
      @listenTo @model.weeks, 'reset add remove', =>
        @data.set(weeksCount: @model.weeks.length)
      @listenTo @model.workouts, 'reset add remove', =>
        @data.set(workoutsCount: @model.workouts.length)