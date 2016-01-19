define [
  './template'
  'features/program_workouts/list/view'
], (
  template
  ProgramWorkoutsListView
) ->

  class ProgramWeeksListItemView extends Marionette.LayoutView

    template: template

    className: 'gc-program-week-item'

    ui:
      removeWeek: '.gc-remove-program-week'

    events:
      'click @ui.removeWeek': 'removeModel'

    behaviors:

      stickit:
        bindings:
          '[data-bind="name"]':
            observe: 'name'
            events: ['change']

      regioned:
        views: [
            region: 'week_workouts'
            klass: ProgramWorkoutsListView
            options: ->
              program = @model.collection.program_template
              collection = new Backbone.VirtualCollection program.workouts,
                filter: (model) => model.get('week_id') == @model.get('id')
                comparator: 'position'
              collection.week_id = @model.get('id')
              model: program
              collection: collection
        ]

    modelEvents:
      'remove': 'weekRemoved'

    removeModel: ->
      App.request('modal:confirm:delete', @model)

    weekRemoved: ->
      App.request 'messenger:explain', 'week.deleted',
        name: @model.get('name')
