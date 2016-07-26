define [
  'pages/base/page'
  './template'
], (
  BasePage
  template
) ->

  class Page extends BasePage

    behaviors:

      navigate_back: true

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    initViews: ->
      root: ->

    onDomRefresh: ->
      @owlCarouselInit()

    owlCarouselInit: ->
      $('#workout-calendar').owlCarousel
        navigation: true
        slideSpeed: 250
        paginationSpeed: 250
        singleItem: true