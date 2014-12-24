Marionette = require 'backbone.marionette'

module.exports = class HeaderView extends Marionette.ItemView
  events:
    "click #temp-logout": "logout"
    "blur #gc-topnav-search": "searchblur"

  initialize: =>
    @template = require '../../templates/general/header'

  logout: (ev)=>
    ev.preventDefault()
    window.localStorage.removeItem 'accessToken'
    App.vent.trigger "startAuthModule"

  searchblur: (ev)->
    ev.preventDefault()
    $sr = $(ev.currentTarget)
    if $sr.val() isnt $sr.attr('placeholder') and $sr.val() isnt ''
      $sr.addClass('active')
    else
      $sr.removeClass('active')
