define [
  'backbone'
], (
  Backbone
) ->

  class GlobalEWPModel extends Backbone.Model

    initialize: (options) ->
      @url = "/api/mobile/#{options.type}"

    duplicate: (data) ->

      options =
        data: JSON.stringify data
        url: "#{@url}/duplicate"

      options = App.request 'ajax:options:create', options

      (@sync || Backbone.sync).call(@, null, @, options)
        .then (response) =>
          @trigger 'model:duplicate:success', response
        .fail (xhr, textStatus, errorThrown) =>
          @trigger 'model:duplicate:fail', @, xhr
