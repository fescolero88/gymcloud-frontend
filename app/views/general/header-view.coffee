Marionette = require 'backbone.marionette'

module.exports = class HeaderView extends Marionette.ItemView
  template: Templates.general.header

  events:
    "blur #gc-topnav-search": "searchblur"

  searchblur: (ev)->
    ev.preventDefault()
    $sr = $(ev.currentTarget)
    if $sr.val() isnt $sr.attr('placeholder') and $sr.val() isnt ''
      $sr.addClass('active')
    else
      $sr.removeClass('active')
