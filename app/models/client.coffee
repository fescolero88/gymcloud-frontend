define [
  './user'
], (
  User
) ->

  class Client extends User

    urlRoot: '/clients'