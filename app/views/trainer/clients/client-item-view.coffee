define [
  'templates/trainer/clients/client-item'
], (
  template
) ->

  class ClientItemView extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'row'

    modelEvents:
      change: 'render'

    ui:
      deleteSingle: '.gc-clients-list-client-delete'
      moveSingle: '.gc-clients-list-client-move'
      checkbox: 'input[type="checkbox"]'

    events:
      'click @ui.deleteSingle': 'deleteSingle'
      'click @ui.moveSingle': 'moveSingle'

    initialize: ->
      App.vent.on 'rm-client', @removeClient

    onDestroy: ->
      App.vent.off 'rm-client', @removeClient

    removeClient: =>
      if @ui.checkbox.is(':checked')
        @model.destroy(wait: true).then =>
          App.request('current_user').clients.remove(@model.id)

    deleteSingle: (ev) =>
      # set name as full name to be recognized by
      # modal:confirm:delete

      @model.set('name', @model.fullName())
      App.request('modal:confirm:delete', @model).then =>
        @model.collection?.remove(@model)
        App.request('current_user').clients.remove(@model.id)

    moveSingle: (ev) =>
      $(ev.currentTarget).closest('.row')
        .find(':checkbox').prop('checked', true)
      @trigger 'individual:move'
