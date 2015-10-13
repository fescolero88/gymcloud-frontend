define ->
  class ProgramWeek extends Backbone.Model

    urlRoot: '/program_weeks/'

    defaults:
      name: undefined
      program_id: undefined
      position: undefined

    setPosition: (pos) ->
      @save(
        'name', "Week #{pos}"
        'position', pos
      ,
        wait: true
      )