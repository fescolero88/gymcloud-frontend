define [
  'views/trainer/clients/client-item-view'
  'templates/trainer/clients/client-list'
], (
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

    viewComparator: (model) ->
      model.get('name') ||
        [
          model.get('user_profile.first_name')
          model.get('user_profile.last_name')
        ].join(' ')

    initialize: (options) ->
      MyId = App.request('current_user_id')
      @collection = new Backbone.VirtualCollection options.collection,
        filter: (model) -> MyId != model.get('id')
