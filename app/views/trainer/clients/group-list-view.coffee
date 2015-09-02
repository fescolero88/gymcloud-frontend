define [
  'backbone.marionette'
  'views/trainer/clients/group-item-view'
  'templates/trainer/clients/group-list'
],
(
  Marionette
  GroupItemView
  template
) ->
  class GroupListView extends Marionette.CompositeView

    template: template

    childView: GroupItemView

    childViewContainer: 'ul'