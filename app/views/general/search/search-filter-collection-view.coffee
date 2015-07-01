Marionette = require 'backbone.marionette'

class SearchFilterItemView extends Marionette.ItemView

  tagName: 'li'

  template: require('templates/general/search/search_filter_item')

  templateHelpers: ->
    url_filter: @url_filter

  ui:
    searchFilterItem: '.gc-search-filter-item'

  onRender: ->
    if @model.get 'isSelected'
      @el.classList.add 'active'

module.exports = class SearchFilterCollectionView extends Marionette.CollectionView
  
  tagName: 'ul'

  childView: SearchFilterItemView

  className: 'gc-content-nav'

