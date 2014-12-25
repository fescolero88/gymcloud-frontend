Marionette = require 'backbone.marionette'
personalBestTemplate = require '../../../templates/trainer/exercises/personal-best'
personalBestEmptyTemplate = require '../../../templates/trainer/exercises/personal-best-empty'

module.exports = class PersonalBestView extends Marionette.ItemView

  template: ->
    if Math.round(Math.random())
       personalBestTemplate
    else
        personalBestEmptyTemplate
