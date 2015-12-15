define [
  './template'
  'features/program_weeks/list/view'
  'features/program_workouts/list/view'
], (
  template
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
            region: 'program_weeks'
            klass: ProgramWeeksListView
            options: ->
              model: @model
              collection: @model.program_weeks
          ,
            region: 'program_workouts'
            klass: ProgramWorkoutsListView
            options: ->
              model: @model
              collection: @model.program_workouts
        ]
