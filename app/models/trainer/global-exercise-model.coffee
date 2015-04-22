Backbone = require 'backbone'

module.exports = class GlobalExerciseModel extends Backbone.Model

  urlRoot: '/api/mobile/exercises/'

  validation:

    name:
      required: true

    description:
      required: false
