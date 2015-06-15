Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ResultsGroupItemView = require 'views/general/search/results-group-item-view'

module.exports = class ResultsGroupsCollectionView extends Marionette.CollectionView
  childView: ResultsGroupItemView