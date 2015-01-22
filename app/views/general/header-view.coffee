Marionette = require 'backbone.marionette'

module.exports = class HeaderView extends Marionette.ItemView
  template: Templates.general.header

  events:
    "blur #gc-topnav-search": "searchblur"

  logout: (ev)=>
    ev.preventDefault()
    window.localStorage.removeItem 'accessToken'

  searchblur: (ev)->
    ev.preventDefault()
    $sr = $(ev.currentTarget)
    if $sr.val() isnt $sr.attr('placeholder') and $sr.val() isnt ''
      $sr.addClass('active')
    else
      $sr.removeClass('active')
