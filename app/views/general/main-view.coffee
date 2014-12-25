Marionette = require 'backbone.marionette'
myTemplate = require '../../templates/general/main'

module.exports = class MainView extends Marionette.LayoutView
  className: 'container-fluid'

  initialize: =>
    @template = myTemplate

  regions:
    'header':    ".gc-topbar"
    'menu':      ".gc-sidebar-wrapper"
    'content':   ".gc-main"
    'modals':    ".gc-modals"
