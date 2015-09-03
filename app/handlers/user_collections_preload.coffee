define [
  'collections/user_collection'
], (
  UserCollection
)->
  (user) ->
    collections = [
      'pros', 'clients', 'client_groups', 'exercises', 'workout_templates',
      'program_templates', 'personal_workouts', 'personal_programs',
      'personal_properties', 'workout_events', 'folders', 'notifications'
    ]
    _.map collections, (item) ->
      collection = new UserCollection [],
        user: user
        type: item
      user.__defineGetter__(item, -> collection)
      collection.fetch()
