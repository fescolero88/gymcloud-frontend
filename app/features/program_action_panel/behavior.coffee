define [
  'behaviors/base/regioned'
  './editable/view'
  './readable/view'
], (
  BaseRegionedBehavior
  EditableBehaviorView
  ReadableBehaviorView
) ->

  class ProgramActionPanelBehavior extends BaseRegionedBehavior

    regionName: 'program_action_panel'

    behaviorViewClass: undefined

    initialize: ->
      @behaviorViewClass = if @options.readonly
        ReadableBehaviorView
      else
        EditableBehaviorView
      super

    behaviorViewOptions: ->
      position: 'top'
      model: _.bind(@options.model, @)()

    defaults:
      model: ->
        @view.model
