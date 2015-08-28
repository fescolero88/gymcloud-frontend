define [
  'backbone.marionette'
  'views/sidebar/personal_collection_item_view'
  'templates/sidebar/user_collection'
], (
  Marionette
  PersonalCollectionItemView
  template
)->
  class PersonalCollectionView extends Marionette.CompositeView

    template: template

    className: 'gc-sidebar-cat'

    childView: PersonalCollectionItemView

    childViewContainer: '.gc-sidebar-sub'

    childViewOptions: ->
      type: @type

    templateHelpers: ->
      type: @type

    initialize: (options)->
      @type = options.type