define ->

  class Helpers

    constructor: (@moment) -> @

    ago: (value) ->
      @moment(value).fromNow()

    full: (value) ->
      @moment(value).format('LLL')
