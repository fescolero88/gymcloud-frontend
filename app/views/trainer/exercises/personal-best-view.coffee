Marionette = require 'backbone.marionette'

module.exports = class PersonalBestView extends Marionette.ItemView

  template: ->
    if Math.round(Math.random())
      Templates.trainer.exercises.personal_best
    else
      Templates.trainer.exercises.personal_best_empty
