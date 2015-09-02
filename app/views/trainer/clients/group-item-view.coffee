define [
  'backbone.marionette'
  'templates/trainer/clients/group-item'
],
(
  Marionette
  template
) ->
  class GroupItemView extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'row'

    modelEvents:
      sync: 'render'
      change: 'render'

    ui:
      deleteSingle: '.gc-clients-list-client-delete'
      checkbox: 'input[type="checkbox"]'

    initialize: ->
      App.vent.on 'rm-group', @removeGroup

    onDestroy: ->
      App.vent.off 'rm-group', @removeGroup

    events:
      'click @ui.deleteSingle': 'deleteSingle'

    @removeGroup: =>
      if @ui.checkbox.is(':checked')
        @model.destroy()

    deleteSingle: (ev) =>
      ev.preventDefault()
      App.request 'base:confirmationalModal',
        title: "Delete group"
        content: "Are you sure you want to delete #{@model.get('name')}?"
        confirmBtn: "Delete"
        confirmCallBack: =>
          @model.destroy()