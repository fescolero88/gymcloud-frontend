define ->

  class FolderItems extends Backbone.Collection

    url: ->
      "/#{@type}"

    initialize: (_models, options) ->
      @type = options?.type

    duplicate: (options) ->
      options = App.request 'ajax:options:create',
        url: "#{@url()}/duplicate"
        data: JSON.stringify
          ids: options.ids
          folder_ids: options.foldersIds

      sync = (@sync || Backbone.sync)
      sync.call(@, null, @, options).then(@_parseDuplicatedModels)

    _parseDuplicatedModels: (response) =>
      user = App.request('current_user')
      models = user[@type].add(response, parse: true)
      _.each models, (model) ->
        folderId = model.get('folder_id')
        folder = user.folders.get(folderId)
        folder.items.add(model)