define [
  'backbone'
  'models/workout_template'
  'models/program_template'
], (
  Backbone
  WorkoutTemplate
  ProgramTemplate
)->
  Exercise = Backbone.Model
  class Folder extends Backbone.Model

    initialize: (options) ->
      @_defineParent()

    urlRoot: "/folders"

    parse: (data, options) ->
      if data.items
        if data.parent_id == null
          data = @_parseRootFolder(data)
        else
          data = @_parseFolder(data, options.type)
        this.items = data.items
        delete data.items
      data

    _parseRootFolder: (data) ->
      items = _.map data.items, (folder) =>
        attrs = @_parseFolder(folder, folder.name)
        folderModel = @_createFolderFromAttrs(attrs)

      data.items = new Backbone.Collection(items)
      data

    _parseFolder: (folderAttrs, type) ->
      items = _.map folderAttrs.items, (entity) =>
        if entity.folder_id
          @_parseEntity(entity, type)
        else
          attrs = @_parseFolder(entity, type)
          folderModel = @_createFolderFromAttrs(attrs)

      folderAttrs.items = new Backbone.Collection(items)
      folderAttrs

    _createFolderFromAttrs: (attrs) ->
      user = App.request('current_user')
      collection = user.folders
      items = attrs.items
      delete attrs.items
      folder = collection.get(attrs.id)
      unless folder
        folder = new Folder(attrs, parse: true)
        collection.add(folder, merge: true)
      folder.items = items
      folder

    _parseEntity: (modelAttrs, type) ->
      user = App.request('current_user')
      collectionName = @_getItemCollectionAttributes(type).collectionName
      collection = user[collectionName]
      model = collection.get(modelAttrs.id)
      unless model
        ModelClass = @_getItemCollectionAttributes(type).modelClass
        model = new ModelClass(modelAttrs, parse: true)
        collection.add(model, merge: true)
      model

    _getItemCollectionAttributes: (folder_name) ->
      {
        Exercises:
          collectionName: 'exercises'
          modelClass: Exercise
        Workouts:
          collectionName: 'workout_templates'
          modelClass: WorkoutTemplate
        Programs:
          collectionName: 'program_templates'
          modelClass: ProgramTemplate
      }[folder_name]

    _defineParent: ->
      @__defineGetter__ 'parent', ->
        user = App.request('current_user')
        collection = user.folders
        collection.get(@get('parent_id'))