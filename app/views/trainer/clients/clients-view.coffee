Marionette = require 'backbone.marionette'

module.exports = class ClientsView extends Marionette.LayoutView
  template: Templates.trainer.clients.clients

  events:
    "click .gc-content-nav-checkall": "toggle_check"
    "click .gc-clients-list-client-chb": "check_all"
    "click #rm-event": "rm_event"
    "change .gc-edit-profile-modal-upload-input": "show_thumbnail"
    "submit .group-form": "submit_group_form"

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

  show_thumbnail: (ev) ->
    input = ev.target
    if input.files && input.files[0]
      reader = new FileReader()
      reader.onload = (e)->
        $(ev.target).parents('form').find('.gc-edit-profile-modal-avatar').attr('src', e.target.result)
      reader.readAsDataURL(input.files[0])

  submit_group_form: (ev) ->
    ev.preventDefault()
    #TODO validation
    name = $(ev.target).find('input[name=group_name]').val()
    avatar = $(ev.target).find('input[type=file]')
    @groups.currentView.trigger 'submit-group-form', name
    @$el.find('#gc-add-group-modal').modal('hide')
