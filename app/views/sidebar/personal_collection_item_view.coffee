define [
  'backbone.marionette'
  'templates/sidebar/user_collection_item'
], (
  Marionette
  template
)->
  Marionette.ItemView.extend

    template: template

    className: 'gc-sidebar-item'