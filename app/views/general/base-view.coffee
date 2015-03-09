Marionette = require 'backbone.marionette'
ModalConfirmView = require 'views/general/modal-confirm-view'

module.exports = class BaseView extends Marionette.LayoutView

  template: Templates.general.base

  el: 'body'

  regions:
    appRegion: "@ui.appRegion"
    confirmRegion: "@ui.confirmRegion"

  ui:
    appRegion: 'region[data-name="app"]'
    confirmRegion: ".confirmational-region"

  initialize: ->
    App.vent.on 'body:change-class', @changeClass
    @on 'showBody', @show

  onDestroy: ->
    App.vent.off 'body:change-class', @changeClass

  show: ->
    @ui.appRegion.removeClass('hide')

  changeClass: (className) =>
    @$el.removeClass().addClass className

  showConfirmModal: (data)->
    confirmView = new ModalConfirmView data
    @confirmRegion.show confirmView

    @listenToOnce confirmView, "modal:closed", ->
      @confirmRegion.destroy()
