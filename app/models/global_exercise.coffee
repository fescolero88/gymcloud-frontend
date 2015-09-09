define ->

  class GlobalExercise extends Backbone.Model

    urlRoot: '/exercises/'

    validation:

      name:
        required: true

      description:
        required: false
