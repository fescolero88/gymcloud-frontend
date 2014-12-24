Marionette = require 'backbone.marionette'

module.exports = class PersonalBestView extends Marionette.ItemView

  initialize: =>
    super
    r = Math.round(Math.random())
    if r
        @template = require '../../../templates/trainer/exercises/personal-best'
    else
        @template = require '../../../templates/trainer/exercises/personal-best-empty'
