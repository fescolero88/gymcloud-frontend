Marionette = require 'backbone.marionette'

class EmptyView extends Marionette.ItemView

  template: Templates.trainer.exercises.personal_best_empty

class BreadcrumbsItemView extends Marionette.ItemView
  template: Templates.trainer.breadcrumbs.breadcrumbs_item
  tagName: 'span'

  modelEvents:
    sync: 'render'

module.exports = class BreadcrumbsView extends Marionette.CompositeView
  childView: BreadcrumbsItemView
  childViewContainer: 'h2'
  emptyView: EmptyView
  template: Templates.trainer.breadcrumbs.breadcrumbs

  collectionEvents:
    sync: 'render'
