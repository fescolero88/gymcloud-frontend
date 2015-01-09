Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

module.exports = class ClientItemView extends Marionette.ItemView
  template: Templates.trainer.clients.client_item
  tagName: 'li'
  className: 'row'

  modelEvents:
    "sync": "render"


module.exports = class ClientListView extends Marionette.CompositeView
  template: Templates.trainer.clients.client_list
  childView: ClientItemView
  childViewContainer: 'ul'

  initialize: =>
    @on 'rm-client', @rm_client
    @on 'submit-client-form', @submitClientForm

  rm_client: =>
    for check in @$el.find('input[type=checkbox]')
      if $(check).is(':checked')
        model = @collection.get $(check).data('id')
        model.destroy()

  submitClientForm: (params)->
    new_client = new Backbone.Model()
    new_client.set params.form_data
    new_client.set 'account_type', 3
    new_client.url = '/api/mobile/clients'
    new_client.save().then =>
      if params.avatar[0].files[0]
        data = new FormData()
        data.append("avatar", params.avatar[0].files[0])
        # Get a new avatar url and then rerender itemview
        $.ajax
          url: "#{new_client.url}/#{new_client.id}/avatar"
          type: 'PUT'
          data: data
          cache: false
          dataType: 'json'
          processData: false
          contentType: false
    @collection.add new_client
