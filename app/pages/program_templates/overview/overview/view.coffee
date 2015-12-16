define [
  './template'
  'features/collections_counters/view'
  'features/program_weeks/list/view'
  'features/program_workouts/list/view'
], (
  template
  CountersView
  ProgramWeeksListView
  ProgramWorkoutsListView
) ->

  class View extends Marionette.LayoutView

    template: template

    className: 'gc-workouts-workout-view'

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
                  collection: @model.program_weeks
                  label: 'weeks'
                ,
                  collection: @model.program_workouts
                  label: 'workouts'
              ]
          ,
            region: 'program_weeks'
            klass: ProgramWeeksListView
            options: ->
              console.log '!!!', @model.program_weeks
              model: @model
              collection: @model.program_weeks
          ,
            region: 'program_workouts'
            klass: ProgramWorkoutsListView
            options: ->
              model: @model
              collection:
                new Backbone.VirtualCollection @model.program_workouts,
                  filter:
                    week_id: undefined
        ]
