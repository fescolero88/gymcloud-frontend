define ->

  class Stats extends Backbone.Collection
    build: (user) ->
      statsObjects = _.map [
          'clients',
          'client_groups',
          'program_templates',
          'workout_templates',
          'personal_programs',
          'personal_workouts'
        ], (property) =>
          {title: _.chain(property).humanize().pluralize(user[property].length)}
      @reset(statsObjects)
