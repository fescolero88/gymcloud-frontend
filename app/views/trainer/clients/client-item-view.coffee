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
        @model.destroy()

    deleteSingle: (ev) =>
      App.request 'modal:confirm',
        title: 'Delete client'
        content: 'Are you sure you want to delete ' +
          "#{@model.get('first_name')} #{@model.get('last_name')}?"
        confirmBtn: 'Delete'
        confirmCallBack: =>
          @model.destroy().then =>
            @model.collection?.remove @model

    moveSingle: (ev) =>
      $(ev.currentTarget).closest('.row')
        .find(':checkbox').prop('checked', true)
      @trigger 'individual:move'
