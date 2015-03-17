Marionette = require 'backbone.marionette'

class EmptyView extends Marionette.ItemView

  template: Templates.trainer.exercises.personal_best_empty

class BreadcrumbsItemView extends Marionette.ItemView
  template: Templates.trainer.breadcrumbs.breadcrumbs_item
  tagName: 'span'

  modelEvents:
    sync: 'render'

class BreadcrumbsCollectionView extends Marionette.CollectionView
  childView: PersonalBestItemView
  childViewContainer: 'h2'
  emptyView: EmptyView

module.exports = class BreadcrumbsView extends Marionette.CompositeView
  template: Templates.trainer.breadcrumbs.breadcrumbs

  initialize: (data) =>
    @itemId = data.itemId
    @assign = data.assign
    @key = data.key

  onShow: =>
    @personalBest = new PersonalBestCollection
    @personalBest.url = "#{@personalBest.urlRoot}/#{@itemId}/#{@assign}/#{@key}/records"
    @personalBest.fetch()
    personalBestView = new PersonalBestCollectionView collection: @personalBest
    @list.show personalBestView
