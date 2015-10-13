define [
  './template'
], (
  template
) ->
  class SearchInputView extends Marionette.ItemView

    template: template

    events:
      'keydown input': 'getSearchQuery'

    behaviors:
      form_validation: true

      stickit:
        bindings:
          'input': 'query'

    getSearchQuery: (event) ->
      return event if event.which != 13
      @trigger('searchStart', @model.get('query'))