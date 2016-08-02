define [
  './item/view'
], (
  ScheduledWorkoutSliderItemView
) ->

  class ScheduledWorkoutSliderView extends Marionette.CollectionView

    className: 'owl-carousel owl-theme'

    attributes:
      id: 'workout-calendar'

    childView: ScheduledWorkoutSliderItemView

    onRenderCollection: ->
      @owlCarousel = @$el.owlCarousel
        navigation: false
        slideSpeed: 250
        paginationSpeed: 250
        singleItem: true

    onDestroy: ->
      @owlCarousel?.destroy?()