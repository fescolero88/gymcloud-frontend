Marionette = require 'backbone.marionette'

module.exports = class ActivityView extends Marionette.ItemView

  template: require('templates/trainer/clients/activity')

  events:
    'click @ui.loadMore': 'loadMore'

  ui:
    loadMore: '.load-more'

  collectionEvents:
    sync: 'render'

  templateHelpers: ->
    noMore: @collection.noMore

  loadMore: (ev) ->
    ev.preventDefault()
    @collection.loadMore()

  refresh: (ev) ->
    @collection.page = 0
    @collection.prevLength = 0
    @collection.loadMore(true)
