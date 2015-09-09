module.exports = class BaseView extends Marionette.LayoutView

  template: require('templates/general/base')

  el: 'body'

  regions:
    appRegion: "@ui.appRegion"
    baseModalRegion: "@ui.baseModalRegion"

  ui:
    appRegion: 'region[data-name="app"]'
    baseModalRegion: ".gc-base-modal-region"

  initialize: ->
    App.vent.on 'body:change-class', @changeClass

  onDestroy: ->
    App.vent.off 'body:change-class', @changeClass

  show: ->

  changeClass: (className) =>
    @$el.removeClass().addClass className
