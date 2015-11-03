define [
  'behaviors/base/regioned'
  './view'
], (
  BaseRegionedBehavior
  View
) ->

  class Behavior extends BaseRegionedBehavior

    regionName: 'video_assigned'

    behaviorViewClass: View

    behaviorViewOptions: ->
      model = _.bind(@options.model, @)
      model: model

    defaults:
      model: ->
        @view.model
