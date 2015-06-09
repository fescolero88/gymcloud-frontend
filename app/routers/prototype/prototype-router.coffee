Marionette = require 'backbone.marionette'
PrototypeController = require 'controllers/prototype/prototype-controller'

module.exports = class PrototypeRouter extends Marionette.AppRouter

  controller: PrototypeController

  appRoutes:
    'prototype/ui': 'ui'
