define [
  'views/trainer/clients/send-message-modal-view'
  '../edit_modal/view'
  'moment'
  './template'
], (
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

    behaviors: ->

      stickit:
        model: => @model.profile
        bindings:
          '.gc-usercard-avatar-wrapper':
            attributes: [
                observe: 'avatar'
                name: 'class'
                onGet: (value) ->
                  if _.any(value.large.url)
                    'gc-usercard-avatar-exist'
            ]
          'img.gc-usercard-avatar':
            attributes: [
                observe: 'avatar'
                name: 'src'
                onGet: (value) ->
                  value.large.url
            ]
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
              date = moment(value)
              if date.isValid() then date.fromNow(true) else ''

    regions:
      clientForm: '#gc-edit-client-modal'
      sendMessageForm: '#gc-send-message-modal'

    ui:
      inviteButton: '.invite-client-button'
      inviteModal: '#gc-invite-client-modal'
      inviteForm: '.invite-client-form'
      inviteEmail: '.invite-client-form input[name=email]'
      clientFormModal: '#gc-edit-client-modal'
      sendMessageModal: '#gc-send-message-modal'

    templateHelpers: ->
      isMyProfile: @_isMyProfile()

    initialize: ->
      @modal = new ProfileEditModalView(model: @model.profile)

      @listenTo @modal, 'modal:close', =>
        @ui.clientFormModal.modal('hide')
      @listenTo(@modal, 'avatarChange', @render)

    onRender: ->
      @getRegion('clientForm').show(@modal)
      @ui.clientFormModal.on 'hidden.bs.modal', (_ev) =>
        @model.profile.set(@modal.previousAttributes)

    onDestroy: ->
      @ui.clientFormModal.off('hidden.bs.modal')

    _isMyProfile: ->
      @model.get('id') is App.request('current_user_id')

    fillClientEmail: ->
      @ui.inviteEmail.val @model.get('email')

    submitClientForm: (ev) ->
      formData = @ui.inviteForm.serializeObject()
      @model.invite(formData.email).then =>
        @ui.inviteModal.modal('hide')

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
      @ui.clientFormModal.modal('show')

    showSendMessageModal: (ev) ->
      selectedItems = [@model.id]
      sendMessageModal = new SendMessageModalView selectedItems: selectedItems
      @sendMessageForm.show sendMessageModal
      @ui.sendMessageModal.modal('show')
      @listenTo sendMessageModal, 'modal:close', =>
        @ui.sendMessageModal.modal('hide')
