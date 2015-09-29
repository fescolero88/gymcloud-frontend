define [
  'backbone'
  'models/workout_template'
  'models/program_template'
  'collections/folder_items'
], (
  Backbone
  WorkoutTemplate
  ProgramTemplate
  FolderItems
)->
  Exercise = Backbone.Model
  class Folder extends Backbone.Model

    initialize: (options) ->
      @_defineParent()

    urlRoot: "/folders"

    validation:
      name:
        required: true

    nestedFolders: ->
      new Backbone.Collection @items.filter (model) ->
        _.isUndefined(model.get('folder_id'))

    nestedEntities: ->
      new Backbone.Collection @items.filter (model) ->
        !_.isUndefined(model.get('folder_id'))

    parse: (data, options) ->
      if data.items
        if data.parent_id == null
          data = @_parseRootFolder(data)
        else
          data = @_parseFolder(data, options.type)
        @items = data.items
        delete data.items
      else
        itemsType = @_getItemCollectionAttributes(options.type)?.collectionName
        if itemsType
          @items = new FolderItems([], type: itemsType)
        else
          @items = new Backbone.Collection
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

      itemsType = @_getItemCollectionAttributes(type).collectionName
      folderAttrs.items = new FolderItems(items, type: itemsType)
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