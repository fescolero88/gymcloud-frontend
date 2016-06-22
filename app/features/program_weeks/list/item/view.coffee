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
              program = @model.collection.program
              collection = new Backbone.VirtualCollection program.workouts,
                filter: (model) => model.get('week_id') == @model.get('id')
                comparator: 'position'
              collection.week_id = @model.get('id')

              weekId: @model.get('id')
              hasEmptyView: true
              model: program
              collection: collection
        ]

    ui:
      removeWeek: '.gc-remove-program-week'
      editButton: '.gc-program-week-actions .fa-edit'

    events:
      'click @ui.editButton': '_editName'
      'click @ui.removeWeek': 'removeModel'

    removeModel: ->
      App.request('modal:confirm:delete', @model)

    _editName: ->
      App.request 'modal:prompt',
        title: 'Edit Week Name'
        prompt: @model.get('name')
        confirmBtn: 'Rename'
        cancelCallBack: -> # nothing
        confirmCallBack: (name) => @model.patch(name: name)
