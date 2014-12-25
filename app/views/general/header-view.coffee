Marionette = require 'backbone.marionette'
myTemplate = require '../../templates/general/header'

module.exports = class HeaderView extends Marionette.ItemView
  events:
    "click #temp-logout": "logout"
    "blur #gc-topnav-search": "searchblur"

  initialize: =>
    @template = myTemplate

  logout: (ev)=>
    ev.preventDefault()
    window.localStorage.removeItem 'accessToken'
    App.vent.trigger "modules:auth:start"

  searchblur: (ev)->
    ev.preventDefault()
    $sr = $(ev.currentTarget)
    if $sr.val() isnt $sr.attr('placeholder') and $sr.val() isnt ''
      $sr.addClass('active')
    else
      $sr.removeClass('active')
