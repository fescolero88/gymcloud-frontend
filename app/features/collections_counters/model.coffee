define ->

  class Model extends Backbone.Model

    defaults:
      label: ''
      count: 0
      collection: undefined

    initialize: ->
      @listenTo @get('collection'), 'update', ->
        @set('count', @get('collection').length)
