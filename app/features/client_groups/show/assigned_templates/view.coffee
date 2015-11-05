define [
  './item/view'
  'models/workout_template'
  'models/program_template'
], (
  AssignedTemplateItemView
  WorkoutTemplate
  ProgramTemplate
) ->
  class AssignedTemplatesListView extends Marionette.CollectionView

    tagName: 'ul'

    className: 'gc-exercises-assign-list'

    childView: AssignedTemplateItemView

    childViewOptions: ->
      clientGroup: @model

    initialize: (data) ->
      @request = @collection.fetch()

    onBeforeDestroy: ->
      @request?.abort?()