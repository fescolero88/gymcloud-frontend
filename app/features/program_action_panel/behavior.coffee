define [
  'behaviors/base/regioned'
  './view'
], (
  BaseRegionedBehavior
  BehaviorView
) ->

  class ProgramActionPanelBehavior extends BaseRegionedBehavior

    regionName: 'program_action_panel'

    behaviorViewClass: BehaviorView

    behaviorViewOptions: ->
      model: _.bind(@options.model, @)()

    defaults:
      model: ->
        @view.model
