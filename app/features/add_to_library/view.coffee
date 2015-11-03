define [
  './folder_list/view'
  'models/global_exercise'
  './template'
], (
  FolderListView
  GlobalExercise
  template
) ->
  class ModalAddToLibraryView extends Marionette.LayoutView

    template: template

    behaviors:

      form_validation: true

    ui:
      form: 'form'

    regions:
      library: '#gc-modal-library-region'

    events:
      'submit @ui.form': '_onSubmit'

    viewData: (new Backbone.Model)

    initialize: (data) ->
      user = App.request('current_user')
      initialFolder = user.getRootFolderFor(@options.type)

      @viewData.set
        folder: initialFolder
        folderList: @_getFolderListView(initialFolder)

      @listenTo(@viewData, 'change:folder', @_onFolderChange)
      @listenTo(@viewData, 'change:folderList', @_showFolderList)

      this

    templateHelpers: ->
      type: @options.type
      typeNameSingle: _.singularize(@options.type)

    onShow: ->
      @getRegion('library').show(@viewData.get('folderList'))

    _showFolderList: (_model, view, _options) ->
      @getRegion('library').show(view)

    _onFolderChange: (_model, folder, _options) ->
      view = @viewData.get('folderList')
      @stopListening(view)
      newView = @_getFolderListView(folder)
      @viewData.set(folderList: newView)

    _getFolderListView: (folder) ->
      folderList = new FolderListView
        type: @options.type
        model: folder

      @listenTo(folderList, 'folder:selected', @_onFolderSelect)
      folderList

    _onFolderSelect: (folder) ->
      @viewData.set(folder: folder)

    _onSubmit: (ev) ->
      ev.preventDefault()

      folder = @viewData.get('folder')
      folder.items.duplicate(
        ids: [@model.id]
        foldersIds: [folder.id]
      ).then =>
        @$el.parent().modal('hide')
        App.request 'messenger:show',
          message: 'Item added to library'
          type: 'success'