Marionette = require 'backbone.marionette'

ClientActivityCollection = require 'models/trainer/activity-collection'
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
    'clientForm': '#gc-edit-client-modal'

  events:
    "click .show-client-form": "showClientEditModal"

  ui:
    clientFormModal: "#gc-edit-client-modal"

  initialize: =>
    clientRecentActivity = new ClientActivityCollection
    clientRecentActivity.url = "/api/mobile/notifications"
    clientRecentActivity.fetch()

    @activityView = new ClientPageActivityView collection: clientRecentActivity

  onShow: =>
    @activity.show @activityView

  showClientEditModal: (ev) ->
    ev.preventDefault()
    profileModel = App.request 'data:profile'
    clientFormModal = new ClientFormModalView model: profileModel

    @listenTo clientFormModal, 'closeModal', =>
      @ui.clientFormModal.modal('hide')
    @listenTo clientFormModal, 'avatarChange', =>
      @render()

    @clientForm.show clientFormModal
    @ui.clientFormModal.modal('show')
