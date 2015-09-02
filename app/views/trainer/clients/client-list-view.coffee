define [
  'backbone.marionette'
  'views/trainer/clients/client-item-view'
  'templates/trainer/clients/client-list'
], (
  Marionette
  ClientItemView
  template
) ->
  class ClientListView extends Marionette.CompositeView

    template: template

    childView: ClientItemView

    childViewContainer: 'ul'

    childEvents:
      'individual:move': 'moveClient'

    moveClient: =>
      @trigger 'individual:move'