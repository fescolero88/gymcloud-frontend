Marionette = require 'backbone.marionette'

ClientTrainer = require 'models/client_trainer'
ClientTrainerActionsView = require 'views/client/client-trainer-actions-view'

module.exports = class ClientPageNavView extends Marionette.LayoutView

  template: require('templates/client/nav')

  regions:
    trainerActions: ".gc-client-trainer-actions"

  initialize: ->
    @model = new ClientTrainer
    @profileModel = App.request 'data:profile'

    App.vent.on 'profile:ready', @render
    App.vent.on 'clientpage:nav-click', (navId) =>
      @$el.find('.gc-clientpage-nav-tab').removeClass('active')
      @$el.find(navId).addClass('active')

    @listenTo @model, 'sync', @onModelSync

  onRender: ->
    if @profileModel.get 'id'
      accountType = @profileModel.get 'account_type'
      if accountType == 'client'
        @model.urlRoot = "#{@model.urlRoot}/#{@profileModel.get 'id'}/trainer"
        @model.fetch()

  onModelSync: ->
    clientTrainerActionsView = new ClientTrainerActionsView model: @model
    @trainerActions.show clientTrainerActionsView
