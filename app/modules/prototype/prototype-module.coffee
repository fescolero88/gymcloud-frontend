PrototypeRouter = require 'routers/prototype/prototype-router'

module.exports = class PrototypeModule extends Marionette.Module

  initialize: ->

    @on 'start', ->
      new PrototypeRouter
