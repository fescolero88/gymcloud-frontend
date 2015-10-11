TrainerController = require 'controllers/trainer/trainer-controller'
TrainerRouter = require 'routers/trainer/trainer-router'

MessagesController = require 'controllers/general/messages/messages-controller'
MessagesRouter = require 'routers/general/messages/messages-router'

MainView = require 'views/general/main-view'
SideBarView = require 'features/sidebar/view'
ModalView = require 'views/general/modal-view'

module.exports = class MainTrainerModule extends Marionette.Module

  initialize: ->
    @on 'start', ->
      @trainerController = new TrainerController
      @trainerRouter = new TrainerRouter
        controller: @trainerController
