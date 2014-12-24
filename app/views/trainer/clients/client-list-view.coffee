Marionette = require 'backbone.marionette'

module.exports = class ClientItemView extends Marionette.ItemView
  template: require '../../../templates/trainer/clients/client-item'
  tagName: 'li'
  className: 'row'

module.exports = class ClientListView extends Marionette.CompositeView
  template: require '../../../templates/trainer/clients/client-list'
  childView: ClientItemView
  childViewContainer: 'ul'

  initialize: =>
    @on 'rm-client', @rm_client

  rm_client: =>
    for check in @$el.find('input[type=checkbox]')
      if $(check).is(':checked')
        model = @collection.get $(check).data('id')
        model.destroy()
