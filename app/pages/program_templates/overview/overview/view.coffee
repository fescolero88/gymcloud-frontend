define [
  './template'
  'features/program_weeks/list/view'
  'features/program_workouts/list/view'
  './empty/view'
  'models/program_workout'
], (
  template
  ProgramWeeksListView
  ProgramWorkoutsListView
  EmptyView
  ProgramWorkout
) ->

  class View extends Marionette.LayoutView

    template: template

    className: 'gc-box-content'

    behaviors:
      editable_textarea: true
      regioned:
        views: [
            region: 'program_weeks'
            klass: ProgramWeeksListView
            options: ->
              collection: @model.weeks
          ,
            region: 'program_workouts'
            klass: ProgramWorkoutsListView
            options: ->
              collection = new Backbone.VirtualCollection @model.workouts,
                filter: (model) -> !model.get('week_id')
                comparator: 'position'
              model: @model
              collection: collection
          ,
            region: 'program_empty'
            klass: EmptyView
            options: ->
              weeks: @model.weeks
              workouts: @model.workouts
        ]

    onShow: ->
      App.request 'fwd',
        context: @
        from: @views.program_workouts_actions
        to: @views.program_workouts
        events: [
          'actions:add'
          'actions:create'
        ]

      @listenTo @views.program_weeks_actions, 'program_weeks:build', =>
        position = @model.weeks.length + 1
        @model.weeks.create
          program_id: @model.get('id')
          position: position
          name: "Week #{position}"
        ,
          wait: true
