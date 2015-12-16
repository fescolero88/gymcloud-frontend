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
            enabled: -> false
            options: ->
              model: @model
              collection:
                new Backbone.Collection
                #new Backbone.VirtualCollection \
                  #@model.collection.program_template.program_workouts,
                  #filter: (item) =>
                    #item.get('week_id') is @model.get('id')
        ]

    modelEvents:
      'remove': 'weekRemoved'

    removeModel: ->
      App.request('modal:confirm:delete', @model)

    weekRemoved: ->
      App.request 'messenger:explain', 'week.deleted',
        name: @model.get('name')
