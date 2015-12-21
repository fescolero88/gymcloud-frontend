define [
  './template'
  'features/collections_counters/view'
  'features/program_weeks/list/view'
  'features/program_workouts/list/view'
  'features/program_weeks/actions/view'
  'features/program_workouts/actions/view'
  'models/program_workout'
], (
  template
  CountersView
  ProgramWeeksListView
  ProgramWorkoutsListView
  ProgramWeeksActionsView
  ProgramWorkoutsActionsView
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
              model: @model
              collection: @model.weeks
          ,
            region: 'program_workouts'
            klass: ProgramWorkoutsListView
            options: ->
              model: @model
              collection:
                new Backbone.VirtualCollection @model.workouts,
                  filter:
                    week_id: null
        ]

    initialize: ->
      # debugger

    onShow: ->
      @listenTo @views.program_weeks_actions, 'program_weeks:build', ->
        @model.weeks.add({})
      @listenTo @views.program_workouts_actions, 'program_workouts:build', ->
        @model.workouts.add({})
      @listenTo @views.program_workouts_actions, 'program_workouts:add', (id) =>
        model = new ProgramWorkout
          program_template_id: @model.get('id')
          workout_template_id: id
        model.save().then =>
          @model.workouts.add(model)
