Marionette = require 'backbone.marionette'

class BreadcrumbsItemView extends Marionette.ItemView

  template: require('templates/general/breadcrumbs/breadcrumbs_item')

  tagName: 'span'

  modelEvents:
    sync: 'render'

module.exports = class BreadcrumbsView extends Marionette.CompositeView

  template: require('templates/general/breadcrumbs/breadcrumbs')

  childView: BreadcrumbsItemView

  childViewContainer: 'h2'

  collectionEvents:
    sync: 'render'
    change: 'render'

  initialize: ->
    App.vent.on 'breadcrumbs:reload', @reloadView

  reloadView: (data) =>
    if data
      @collection.set data
