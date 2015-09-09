define ->

  class ClientGroup extends Backbone.Model

    urlRoot: '/api/mobile/client_groups'

    validation:

      name:
        required: true

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
