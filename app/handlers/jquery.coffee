define [
  'jquery'
  'underscore'
], (
  $
  _
) ->

  handlers =

    falseLinks: ->
      selector = [
        "a:not('[href]')"
        '[href="#"]'
      ].join(', ')
      $(document)
        .on 'click', selector, (event) ->
          event.preventDefault()
          false

    falseForms: ->
      selector = [
        "form:not('[action]')"
      ].join(', ')
      document
        .addEventListener 'submit', (event) ->
          el = $(event.target)
          if el.is(selector)
            event.preventDefault()
            false
          else
            true

  ->
    _.each handlers, (fn) -> fn()
