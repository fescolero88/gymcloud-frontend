define [
  'models/workout_template'
], (
  WorkoutTemplate
) ->

  class AssignedWorkoutTemplatesToClientGroup extends Backbone.Collection

    model: WorkoutTemplate

    url: ->
      "#{@clientGroup.url()}/assignments/workout_templates"

    constructor: (options) ->
      @clientGroup = options.clientGroup
      super