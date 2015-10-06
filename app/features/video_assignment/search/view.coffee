define [
  './template'
  'collections/videos'
], (
  template
  ExerciseVideosCollection
) ->
  class SearchView extends Marionette.ItemView

    template: template

    events:
      'keydown input': 'getSearchQuery'

    initialize: (options) ->
      @collection = options.collection
      @request = null

    getSearchQuery: (event) ->
      return false if event.which != 13
      query = $(event.currentTarget).val()
      @request?.abort()
      @request = @collection.search(query)
        .then (response) =>
          @collection.reset(response)
        .fail ->
          # Notification ?