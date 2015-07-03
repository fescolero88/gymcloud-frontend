Marionette = require 'backbone.marionette'
module.exports = class MainView extends Marionette.LayoutView

  template: require('templates/general/main')

  className: 'container-fluid'

  initialize: =>
    App.vent.on 'drag:start', @dragStart
    App.vent.on 'drag:drop', @drop

  onDestroy: =>
    App.vent.off 'drag:start', @dragStart
    App.vent.off 'drag:drop', @drop

  onShow: =>
    App.vent.trigger 'body:change-class', 'main'

  ui:
    dndArea: '.gc-dnd-area'
    mainArea: '.gc-main'

  regions:
    header: '.gc-topbar'
    menu: '.gc-sidebar-wrapper'
    content: '.gc-main'
    modals: '.gc-modals'

  dragStart: =>
    if @content.currentView.isDroppable
      @ui.dndArea.appendTo(@ui.mainArea)

  drop: (model, e) =>
    if @content.currentView.isDroppable
      offset = @ui.mainArea.offset()
      dropped = (e.pageX >= offset.left and e.pageY >= offset.top)
      if dropped
        App.vent.trigger 'drag:complete', model
      @ui.dndArea.appendTo('body')
