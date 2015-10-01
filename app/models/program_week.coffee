define ->
  class ProgramWeek extends Backbone.Model

    urlRoot: '/program_weeks/'

    defaults:
      name: undefined
      program_id: undefined
      position: undefined

    setPosition: (pos) ->
      @set 'name', "Week #{pos}"
      @set 'position', pos
      @save()