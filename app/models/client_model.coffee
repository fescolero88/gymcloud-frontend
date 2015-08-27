define [
  'backbone'
], (
  Backbone
) ->

  class ClientModel extends Backbone.Model

    urlRoot: '/api/mobile/clients'

    validation:

      first_name:
        required: true

      last_name:
        required: true

      email:
        required: true
        pattern: 'email'

      weight:
        required: false
        isFloat: true

      height:
        required: false
        isFloat: true

      bodyfat:
        required: false
        isFloat: true

      address:
        required: false

      zip:
        required: false
        pattern: 'digits'

      works_at:
        required: false

    updateAvatar: (formData) ->
      options =
        url: "#{@urlRoot}/#{@id}/avatar"
        type: 'PUT'
        data: formData
        processData: false
        contentType: false

      (@sync || Backbone.sync).call(@, null, @, options)
        .then (response) =>
          @trigger 'model:avatar_update:success', response
        .fail (xhr, textStatus, errorThrown) =>
          @trigger 'model:avatar_update:fail', 'Something went wrong'

    invite: (data, url) ->
      options =
        url: url
        data: JSON.stringify data

      options = App.request 'ajax:options:create', options

      (@sync || Backbone.sync).call(@, null, @, options)
        .then (response) =>
          @trigger 'model:invite:success', response
        .fail (xhr, textStatus, errorThrown) =>
          @trigger 'model:invite:fail', xhr.responseJSON?.error || null
