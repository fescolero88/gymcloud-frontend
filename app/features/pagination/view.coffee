define [
  './template'
], (
  template
) ->
  class PaginationView extends Marionette.ItemView

    template: template

    ui:
      prevPage: '.pagination li:first a'
      nextPage: '.pagination li:last a'
      searchPage: '.pagination li:not(:first, :last) a'

    events:
      'click @ui.prevPage': 'getPrevPage'
      'click @ui.nextPage': 'getNextPage'
      'click @ui.searchPage': 'getSearchPage'

    getPrevPage: (ev) ->
      ev.preventDefault()
      @collection.getPreviousPage()

    getNextPage: (ev) ->
      ev.preventDefault()
      @collection.getNextPage()

    getSearchPage: (ev) ->
      ev.preventDefault()
      page = parseInt $(ev.currentTarget).text()
      @collection.getPage(page)