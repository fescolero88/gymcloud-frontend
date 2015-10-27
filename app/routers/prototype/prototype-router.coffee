CustomRouter  = require 'routers/general/custom-router'
PrototypeController = require 'controllers/prototype/prototype-controller'

module.exports = class PrototypeRouter extends CustomRouter

  controller: PrototypeController

  appRoutes:
    'prototype/ui': 'ui'
    'ui/template/:templateName': 'renderTemplate'
