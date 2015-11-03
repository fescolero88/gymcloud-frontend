define [
  './template'
], (
  template
) ->
  class SearchInputView extends Marionette.ItemView

    template: template

    events:
      'keydown input': 'getSearchQuery'
      'click .video-search-btn': 'getSearchQuery'

    behaviors:
      form_validation: true

      stickit:
        bindings:
          'input': 'query'

    getSearchQuery: (event) ->
      if (event.which isnt 13 and
      not $(event.target).hasClass('video-search-btn'))
        return event
      @trigger('searchStart', @model.get('query'))