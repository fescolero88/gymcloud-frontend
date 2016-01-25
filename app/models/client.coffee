define [
  './user'
], (
  User
) ->

  class Client extends User

    type: 'Client'

    urlRoot: '/clients'
