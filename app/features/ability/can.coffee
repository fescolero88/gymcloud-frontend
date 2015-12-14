define [
  'cancan'
  'app/features/current_user/model'
  './namespaces/exercises'
  './namespaces/workout_templates'
], (
  cancan
  User
  exercises
  workout_templates
) ->

  namespaces = [
    exercises
    workout_templates
  ]

  cancan.configure User, (user) ->
    ctx = @
    namespaces.forEach (ability) ->
      ability.apply(ctx, [user])

  can = cancan.can

  ->
    user = App.request('current_user')
    can(user, arguments...)
