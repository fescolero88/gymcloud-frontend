Marionette = require 'backbone.marionette'

module.exports = class MainView extends Marionette.LayoutView
  template: Templates.general.main
  className: 'container-fluid'

  regions:
    'header':    ".gc-topbar"
    'menu':      ".gc-sidebar-wrapper"
    'content':   ".gc-main"
    'modals':    ".gc-modals"
