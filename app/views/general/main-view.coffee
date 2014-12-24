Marionette = require 'backbone.marionette'

module.exports = class MainView extends Marionette.LayoutView
  className: 'container-fluid'

  initialize: =>
    @template = require '../../templates/general/main'

  regions:
    'header':    ".gc-topbar"
    'menu':      ".gc-sidebar-wrapper"
    'content':   ".gc-main"
    'modals':    ".gc-modals"
