Marionette = require 'backbone.marionette'

class BreadcrumbsItemView extends Marionette.ItemView
  template: Templates.general.breadcrumbs.breadcrumbs_item
  tagName: 'span'

  modelEvents:
    sync: 'render'

module.exports = class BreadcrumbsView extends Marionette.CompositeView
  childView: BreadcrumbsItemView
  childViewContainer: 'h2'
  template: Templates.general.breadcrumbs.breadcrumbs

  collectionEvents:
    sync: 'render'
