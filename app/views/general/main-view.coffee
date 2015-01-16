Marionette = require 'backbone.marionette'

module.exports = class MainView extends Marionette.LayoutView
  template: Templates.general.main
  className: 'container-fluid'

  initialize: =>
    App.vent.on 'drag:start', @dragStart
    App.vent.on 'drag:drop', @drop

  onDestroy: =>
    App.vent.off 'drag:start', @dragStart
    App.vent.off 'drag:drop', @drop

  ui:
    dndArea: ".gc-dnd-area"
    mainArea: ".gc-main"

  regions:
    'header':    ".gc-topbar"
    'menu':      ".gc-sidebar-wrapper"
    'content':   ".gc-main"
    'modals':    ".gc-modals"

  dragStart: =>
    @ui.dndArea.appendTo(@ui.mainArea)

  drop: (model, e) =>
    offset = @ui.mainArea.offset()
    dropped = (e.pageX >= offset.left and e.pageY >= offset.top)
    if dropped
      console.debug 'Assigned item #' + model.get 'key'
    @ui.dndArea.appendTo('body')
