Marionette = require 'backbone.marionette'
myTemplate = require '../../../templates/trainer/clients/client-nav'

module.exports = class ClientNavView extends Marionette.ItemView
  template: myTemplate

  events:
    'click .gc-content-nav :not(.gc-content-nav-back) a': 'navLinkClick'
    'click .gc-content-nav-back a': 'navBack'

  navLinkClick: (ev) ->
    $('.gc-content-nav a').parent().removeClass('active')
    $(ev.currentTarget).parent().addClass('active')

  navBack: (ev) ->
    window.history.back()
