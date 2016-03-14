define [
  './user'
], (
  User
) ->

  class Client extends User

    type: 'Client'

    urlRoot: '/clients'

    validation:
      email:
        required: true
        pattern: 'email'
        msg: 'Please enter a valid email'

    computed:
      name:
        toJSON: false
        depends: [
          'first_name'
          'last_name'
        ]
        get: (fields) ->
          _.compact([fields.first_name, fields.last_name]).join(' ')
        set: (value, fields) ->
          [fields.first_name, fields.last_name] = _.compact(value.split(' '))

    initialize: ->
      @computedFields = new Backbone.ComputedFields(@)
