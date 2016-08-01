define [
  'pages/base/page'
  './template'
], (
  BasePage
  template
) ->

  class Page extends BasePage

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    initModel: ->
      new Backbone.Model

    initViews: ->
      root: ->

    ui: calendar: '#workout-calendar'

    onDomRefresh: ->
      @_owlCarouselInit()

    _owlCarouselInit: ->
      @ui.calendar.owlCarousel
        navigation: true
        slideSpeed: 250
        paginationSpeed: 250
        singleItem: true