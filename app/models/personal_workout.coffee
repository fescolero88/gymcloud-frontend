define ->

  class PersonalWorkout extends Backbone.Model

    urlRoot: '/personal_workouts'

    person: ->
      person_id = @get('person_id')
      App.request('current_user').clients.get(person_id)
