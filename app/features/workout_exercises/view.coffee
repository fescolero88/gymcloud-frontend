define [
  './template'
  './list/view'
  './actions/view'
], (
  template
  ListView
  ActionsView
) ->

  class View extends Marionette.LayoutView

    template: template

    className: 'gc-workouts-exercises-view'

    behaviors:

      regioned:
        views: [
            region: 'workout_exercises_list'
            klass: ListView
          ,
            region: 'workout_exercises_actions'
            klass: ActionsView
            enabled: ->
              can('update', @model)
        ]

    onShow: ->
      App.request 'fwd',
        context: @
        from: @views.workout_exercises_actions
        to: @views.workout_exercises_list
        events: [
          'actions:add'
          'actions:create'
          'actions:multi_constructor:start'
          'actions:multi_constructor:stop'
          'actions:multi_constructor:assign'
        ]
