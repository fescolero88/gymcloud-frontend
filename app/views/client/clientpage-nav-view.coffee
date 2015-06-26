Marionette = require 'backbone.marionette'

module.exports = class ClientPageNavView extends Marionette.ItemView

  template: require('templates/client/nav')

  initialize: ->
    App.vent.on 'clientpage:nav-click', (navId) =>
      @$el.find('.gc-clientpage-nav-tab').removeClass('active')
      @$el.find(navId).addClass('active')
