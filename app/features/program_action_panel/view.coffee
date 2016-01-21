define [
  './template'
  './model'
], (
  template
  DataModel
) ->

  class View extends Marionette.LayoutView

    template: template

    className: 'program-action-panel row'

    behaviors:
      author_widget: true
      privacy_widget: true

      stickit:
        model: -> @data
        bindings:
          '.counter.weeks': 'weeksCount'
          '.counter.workouts': 'workoutsCount'

    events:
      'click button.add-week': '_addWeek'

    initialize: ->
      @data = new DataModel
      @listenTo @model.weeks, 'reset add remove', =>
        @data.set(weeksCount: @model.weeks.length)
      @listenTo @model.workouts, 'reset add remove', =>
        @data.set(workoutsCount: @model.workouts.length)

    _addWeek: ->
      position = @model.weeks.length + 1
      @model.weeks.create
        program_id: @model.get('id')
        position: position
        name: "Week #{position}"
      ,
        wait: true