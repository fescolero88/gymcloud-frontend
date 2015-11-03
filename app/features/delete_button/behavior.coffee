define [
  'behaviors/base/regioned'
  './view'
], (
  BaseRegionedBehavior
  BehaviorView
) ->

  class DeleteButtonBehavior extends BaseRegionedBehavior

    regionName: 'delete_button'

    behaviorViewClass: BehaviorView

    behaviorViewOptions: ->
      model: @view.model
