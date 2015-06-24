Marionette = require 'backbone.marionette'

module.exports = class SearchBarView extends Marionette.ItemView

  template: Templates.general.search.search_bar

  events:
    'blur @ui.searchTerm': 'searchFocusLost'
    'click @ui.searchIcon': 'search'
    'keypress @ui.searchTerm' : 'searchOnEnter'
    'focus @ui.searchTerm': 'activateSearch'

  ui:
    searchTerm: '#gc-topnav-search'
    searchIcon: '.gc-topnav-search-icon'

  className: 'gc-topbar-search'

  searchOnEnter: (ev)->
    @search(ev) if ev.which is 13
    @cancelSearch if ev.which is 27

  doSearch: (q)->
    if q isnt ''
      App.vent.trigger 'search:global', q
    else
      alert 'Enter search term'

  activateSearch: ->
    @ui.searchIcon.removeClass('glyphicon-search')
    @ui.searchIcon.addClass('glyphicon-remove')

  cancelSearch: ->
    @ui.searchTerm.val('')
    @ui.searchIcon.addClass('glyphicon-search')
    @ui.searchIcon.removeClass('glyphicon-remove')
    App.vent.trigger 'search:cancel'

  search: (ev) ->
    ev.preventDefault()
    isSearchInProgress = $(ev.target).hasClass('glyphicon-remove')
    if isSearchInProgress
      do @cancelSearch
    else
      @doSearch(@ui.searchTerm.val())

  searchFocusLost: (ev) ->
    console.log 'search lost focus'
    ev.preventDefault()
    $sr = $(ev.currentTarget)
    if $sr.val() isnt $sr.attr('placeholder') and $sr.val() isnt ''
      $sr.addClass('active')
    else
      $sr.removeClass('active')
      @cancelSearch()


