Marionette = require 'backbone.marionette'

module.exports = class BaseView extends Marionette.LayoutView

  template: Templates.general.base

  el: 'body'

  regions:
    appRegion: "@ui.appRegion"
    baseModalRegion: "@ui.baseModalRegion"

  ui:
    appRegion: 'region[data-name="app"]'
    baseModalRegion: ".gc-base-modal-region"

  initialize: ->
    App.vent.on 'body:change-class', @changeClass
    @on 'showBody', @show

  onDestroy: ->
    App.vent.off 'body:change-class', @changeClass

  show: ->
    @ui.appRegion.removeClass('hide')

  changeClass: (className) =>
    @$el.removeClass().addClass className
