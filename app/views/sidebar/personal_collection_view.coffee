define [
  'backbone.marionette'
  'views/sidebar/personal_collection_item_view'
  'templates/sidebar/user_collection'
], (
  Marionette
  PersonalCollectionItemView
  template
)->
  Marionette.CompositeView.extend

    template: template

    className: 'gc-sidebar-cat'

    childView: PersonalCollectionItemView

    childViewContainer: '.gc-sidebar-sub'

    templateHelpers: ->
      type: @type

    initialize: (options)->
      @type = options.type