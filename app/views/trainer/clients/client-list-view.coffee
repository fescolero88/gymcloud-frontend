Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ClientModel = require 'models/trainer/client-model'

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

  ui:
    checkedCheckboxes: 'input[type=checkbox]:checked'

  initialize: =>
    @on 'rm-client', @rmClient
    @on 'submit-client-form', @submitClientForm

  rmClient: =>
    for check in @$el.find('input[type=checkbox]')
      if $(check).is(':checked')
        model = @collection.get $(check).data('id')
        model.destroy()

  submitClientForm: (params)->
    newClient = new ClientModel
    newClient.set params.form_data
    newClient.set 'account_type', 3
    newClient.save().then =>
      newClient.url = "/api/mobile/clients/#{newClient.id}"
      if params.avatar[0].files[0]
        data = new FormData()
        data.append("avatar", params.avatar[0].files[0])
        # Get a new avatar url and then rerender itemview
        $.ajax
          url: "#{newClient.url}/#{newClient.id}/avatar"
          type: 'PUT'
          data: data
          cache: false
          dataType: 'json'
          processData: false
          contentType: false
      @collection.add newClient
