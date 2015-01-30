Marionette = require 'backbone.marionette'

ClientActivityCollection = require 'models/trainer/activity-collection'
ClientProfileView = require 'views/client/clientpage-profile-view'
ClientPageActivityView = require 'views/client/clientpage-activity-view'
ClientFormModalView = require 'views/trainer/clients/client-form-modal-view'
ClientModel = require 'models/trainer/client-model'

module.exports = class ClientPageSidebarView extends Marionette.LayoutView
  template: Templates.client.sidebar
  autoRender: false

  modelEvents:
    "sync": "render"

  regions:
    'activity': '#gc-clientpage-sidebar-activity'
    'profile': '#gc-clientpage-sidebar-profile'
    'clientForm': '#gc-edit-client-modal'

  events:
    "click .show-client-form": "showClientEditModal"

  ui:
    clientFormModal: "#gc-edit-client-modal"

  initialize: =>
    App.vent.on 'profile:ready', @updateProfile

  onDestroy: =>
    App.vent.off 'profile:ready', @updateProfile

  onShow: =>
    clientRecentActivity = new ClientActivityCollection
    clientRecentActivity.url = "/api/mobile/notifications"
    clientRecentActivity.fetch()

    @activityView = new ClientPageActivityView collection: clientRecentActivity

    @activity.show @activityView

  showClientEditModal: (ev) ->
    ev.preventDefault()
    profileModel = App.request 'data:profile'
    clientFormModal = new ClientFormModalView model: profileModel

    @listenTo clientFormModal, 'closeModal', =>
      @ui.clientFormModal.modal('hide')
    @listenTo clientFormModal, 'avatarChange', =>
      @profile.show new ClientProfileView

    @clientForm.show clientFormModal
    @ui.clientFormModal.modal('show')

  updateProfile: =>
    @profile.show new ClientProfileView

