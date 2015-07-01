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
