define [
  'behaviors/base/regioned'
  './view'
], (
  BaseRegionedBehavior
  BreadcrumbsView
) ->

  class BreadcrumbsBehavior extends BaseRegionedBehavior

    regionName: 'breadcrumbs'

    behaviorViewClass: BreadcrumbsView

    behaviorViewOptions: ->
      model: _.bind(@options.model, @)

    defaults:
      model: ->
        @view.model
