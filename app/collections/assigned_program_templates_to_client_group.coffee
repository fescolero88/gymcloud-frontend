define [
  'models/program_template'
], (
  ProgramTemplate
) ->

  class AssignedWorkoutTemplatesToClientGroup extends Backbone.Collection

    model: ProgramTemplate

    url: ->
      "#{@clientGroup.url()}/assignments/program_templates"

    constructor: (options) ->
      @clientGroup = options.clientGroup
      super