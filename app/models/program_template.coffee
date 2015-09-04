define [
  'backbone'
  './workout_template'
], (
  Backbone
  WorkoutTemplate
) ->

  class ProgramTemplate extends Backbone.Model

    urlRoot: '/program_templates/'

    validation:

      name:
        required: true