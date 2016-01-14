define [
  './template'
  'features/collections_counters/view'
  'features/program_weeks/list/view'
  'features/program_workouts/list/view'
  'features/program_weeks/actions/view'
  'features/program_workouts/actions/view'
  './empty/view'
  'models/program_workout'
], (
  template
  CountersView
  ProgramWeeksListView
  ProgramWorkoutsListView
  ProgramWeeksActionsView
  ProgramWorkoutsActionsView
  EmptyView
  ProgramWorkout
) ->

  class View extends Marionette.LayoutView

    template: template

    className: 'gc-box-content'

    behaviors:
      author_widget: true
      rating_widget: true
      editable_textarea: true
      privacy_toggle: true
      delete_button: true
      regioned:
        views: [
            region: 'counters'
            klass: CountersView
            options: ->
              collections: [
                  collection: @model.weeks
                  label: 'weeks'
                ,
                  collection: @model.workouts
                  label: 'workouts'
              ]
          ,
            region: 'program_weeks_actions'
            klass: ProgramWeeksActionsView
          ,
            region: 'program_workouts_actions'
            klass: ProgramWorkoutsActionsView
          ,
            region: 'program_weeks'
            klass: ProgramWeeksListView
            options: ->
              collection: @model.weeks
          ,
            region: 'program_workouts'
            klass: ProgramWorkoutsListView
            options: ->
              model: @model
              collection:
                new Backbone.VirtualCollection @model.workouts,
                  filter: (model) -> !model.get('week_id')
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
        model = @model.weeks.add
          program_id: @model.get('id')
          position: position
          name: "Week #{position}"
        model.save().then =>
          @model.weeks.add(model)
