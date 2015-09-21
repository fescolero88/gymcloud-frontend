ClientTrainer = require 'models/client_trainer'
ClientTrainerActionsView = require 'views/client/client-trainer-actions-view'

module.exports = class ClientPageNavView extends Marionette.LayoutView

  template: require('templates/client/nav')

  regions:
    trainerActions: ".gc-client-trainer-actions"

  ui:
    navTitle: '.gc-clientpage-nav-title'

  initialize: ->
    @model = new ClientTrainer
    @profileModel = App.request 'current_user'

    App.vent.on 'profile:ready', @render
    App.vent.on 'clientpage:nav-click', (navId) =>
      @$el.find('.gc-clientpage-nav-tab').removeClass('active')
      @$el.find(navId).addClass('active')

    @listenTo @model, 'sync', @onModelSync

    App.vent.on 'client:nav:change', @changeType

  onDestroy: ->
    App.vent.off 'client:nav:change', @changeType

  changeType: (type) =>
    @ui.navTitle.html type

  onRender: ->
    if @profileModel.get 'id'
      isPro = @profileModel.get 'is_pro'
      unless isPro
        @model.urlRoot = "#{@model.urlRoot}/#{@profileModel.get 'id'}/trainer"
        @model.fetch()

  onModelSync: ->
    clientTrainerActionsView = new ClientTrainerActionsView model: @model
    @trainerActions.show clientTrainerActionsView
