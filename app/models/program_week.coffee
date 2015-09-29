define ->
  class ProgramWeek extends Backbone.Model

    urlRoot: '/program_weeks/'

    defaults:
      name: undefined
      program_id: undefined
      position: undefined