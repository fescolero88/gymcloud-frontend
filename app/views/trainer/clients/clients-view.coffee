Marionette = require 'backbone.marionette'

module.exports = class ClientsView extends Marionette.LayoutView
  template: Templates.trainer.clients.clients

  events:
    "click .gc-content-nav-checkall": "toggle_check"
    "click .gc-clients-list-client-chb": "check_all"
    "click #rm-event": "rm_event"

  ui:
    mainCheckbox: ".gc-content-nav-checkall input[type='checkbox']"

  regions:
    'clients': '#clients-region'
    'groups': '#groups-region'

  templateHelpers: =>
    view_type: @view_type

  initialize: (view_type)=>
    @view_type = view_type

  toggle_check: (ev) =>
    checked = @ui.mainCheckbox.is(':checked')
    @$el.find('.gc-clients-list-wrapper').find('input[type=checkbox]').prop('checked', checked)

  check_all: (ev) =>
    for check in @$el.find('.gc-clients-list-wrapper').find('input[type=checkbox]')
      if need_toggle?
        if need_toggle != $(check).is(':checked')
          @ui.mainCheckbox.prop 'checked', false
          return
      need_toggle = $(check).is(':checked')
    if need_toggle
      @ui.mainCheckbox.prop 'checked', true

  rm_event: (ev) =>
    ev.preventDefault()
    @clients.currentView.trigger 'rm-client'
    @groups.currentView.trigger 'rm-group'
