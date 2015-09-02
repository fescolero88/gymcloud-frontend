define [
  'backbone.marionette'
  'views/trainer/clients/send-message-modal-view'
  '../edit_modal/view'
  'moment'
  './template'
], (
  Marionette
  SendMessageModalView
  ProfileEditModalView
  moment
  template
) ->
  class HeaderView extends Marionette.LayoutView

    template: template

    autoRender: false

    modelEvents:
      'sync': 'render'
      'model:invite:success': 'onInvite'
      'model:invite:fail': 'onInviteFail'

    events:
      'submit @ui.inviteForm': 'submitClientForm'
      'click .show-client-form': 'showClientEditModal'
      'click .show-message-form': 'showSendMessageModal'
      'show.bs.modal @ui.inviteModal': 'fillClientEmail'

    bindings:
      'span[data-bind="location"]': 'location'
      'span[data-bind="zip"]': 'zip'
      'span[data-bind="first_name"]': 'first_name'
      'span[data-bind="last_name"]': 'last_name'
      'dd[data-bind="height"]': 'height'
      'dd[data-bind="weight"]': 'weight'
      'dd[data-bind="bodyfat"]': 'bodyfat'
      'dd[data-bind="gender"]': 'gender'
      'dd[data-bind="birthday"]':
        observe: 'birthday'
        onGet: (value)->
          moment(value).fromNow(true)

    regions:
      clientForm: '#gc-edit-client-modal'
      sendMessageForm: '#gc-send-message-modal'

    ui:
      inviteModal: '#gc-invite-client-modal'
      inviteForm: '.invite-client-form'
      inviteEmail: '.invite-client-form input[name=email]'
      clientFormModal: '#gc-edit-client-modal'
      sendMessageModal: '#gc-send-message-modal'

    initialize: (data) ->
      @viewType = data.viewType
      @profile = App.request 'current_user'
      if @model.get('id') is @profile.get('id')
        @myProfile = true

    onRender: ->
      @stickit(@model.profile)

    onDestroy: ->
      @unstickit(@model.profile)

    templateHelpers: =>
      if @viewType is 'clients' then view_type = 1 else view_type = 0
      {view_type: view_type, myProfile: @myProfile}

    fillClientEmail: ->
      @ui.inviteEmail.val @model.get('email')

    submitClientForm: (ev) ->
      #TODO validation
      ev.preventDefault()
      formData = @ui.inviteForm.serializeObject()
      if @myProfile
        url = "/api/mobile/me/invite"
      else
        url = "/api/mobile/clients/#{@model.get('id')}/invite"

      @model.invite(formData, url)

    onInvite: ->
      @ui.inviteModal.modal('hide')
      App.request 'messenger:show',
        message: 'Invitation successfully sent'
        type: 'info'

    onInviteFail: (error) ->
      if error?
        $input = @ui.inviteForm.find('input[name=email]')
        $inputGroup = $input.closest('.form-group')
        $inputGroup.removeClass('gc-valid').addClass('gc-invalid')
        $inputGroup.find('.gc-error-message').text(error)

    showClientEditModal: (ev) ->
      ev.preventDefault()
      model = @model.profile
      view = new ProfileEditModalView(model: model)

      @listenTo view, 'modal:close', =>
        @ui.clientFormModal.modal('hide')
        if model.changedAttributes()
          oldAttributes = model.previousAttributes()
          model.set(oldAttributes)

      @listenTo view, 'avatarChange', =>
        @render()

      @clientForm.show(view)
      @ui.clientFormModal.modal('show')

    showSendMessageModal: (ev) ->
      selectedItems = [@model.id]
      sendMessageModal = new SendMessageModalView selectedItems: selectedItems
      @sendMessageForm.show sendMessageModal
      @ui.sendMessageModal.modal('show')
      @listenTo sendMessageModal, 'modal:close', =>
        @ui.sendMessageModal.modal('hide')
