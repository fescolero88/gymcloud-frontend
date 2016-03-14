define [
  './user'
], (
  User
) ->

  class Client extends User

    type: 'Client'

    urlRoot: '/clients'

    validation: ->
      obj =
        name:
          required: true
          pattern: /\w+\s+\w+$/
          msg: 'Please enter a first name and a last name'

      if @get('invite') or !!@get('email')
        obj.email =
          required: true
          pattern: 'email'
          msg: 'Please enter a valid email'
      obj

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
