ModalAddToLibraryLibraryView = require 'views/general/modal_add_to_library_library_view'
GlobalExercise = require 'models/global_exercise'

module.exports = class ModalAddToLibraryView extends Marionette.LayoutView

  template: require('templates/general/modal_add_to_library')

  behaviors:

    form_validation: true

  ui:
    form: 'form'
    modal: ".modal"
    input: '.gc-new-item-name-input'

  regions:
    library: '#gc-modal-library-region'

  events:
    "submit @ui.form": "submit"
    'change @ui.input': 'nameChanged'
    "hidden.bs.modal @ui.modal": "closeModal"

  initialize: (data) ->
    @type = data.type
    @model = data.model
    @itemsView = new ModalAddToLibraryLibraryView type: @type, name: @model.get('name')
    @listenTo @itemsView, 'folder:selected', @folderSelected
    @listenTo @itemsView, 'name:changed', @nameChanged

  templateHelpers: ->
    type: @type
    typeNameSingle: @type.substring(0, @type.length - 1)
    model: @model.attributes

  onShow: ->
    #@ui.modal.modal()
    @library.show @itemsView
    @name = @ui.input.val()

  submit: (ev) ->
    if @name
      root_id = App.request "data:#{@type}:root"
      if not @parent_id
        @parent_id = root_id
      typeSingle = @type.substring(0, @type.length - 1)
      @model.set "#{typeSingle}_folder_id", @parent_id
      @model.set "name", @name

      $.ajax
        method: 'POST'
        url: "/api/mobile/#{@type}/#{@model.get('id')}/import"
        dataType: 'json'
        data: JSON.stringify @model.attributes
        success: (model) =>
          App.request 'spinner:start'
          importedModel = new GlobalExercise(model)
          importedModel.set 'name', @name
          importedModel.set 'exercise_folder_id', @parent_id
          importedModel.url = importedModel.urlRoot + importedModel.get('id')
          importedModel.save null,
            success: (model, data) =>
              App.request('data:reload', @type, App.request "data:#{@type}:root").then =>
                @closeModal()
                App.request ''
                App.request 'messenger:show',
                  message: "Item added to your library"
                window.location.replace "#tr/global/exercises/id/#{data.id}"
        statusCode:
          403: (data) =>
            App.request 'messenger:show',
              type: 'error'
              message: "Something goes wrong, please, try again later"
            @closeModal()

  folderSelected: (key) =>
    @parent_id = key

  nameChanged: (ev) =>
    ev.preventDefault()
    @name = @ui.input.val()
    if not @name
      @trigger 'switchError', 'Please, enter name', @ui.input.closest('.form-group')
    else
      @trigger 'switchError', "", @ui.input.closest('.form-group')

  closeModal: ->
    #@ui.modal.modal('hide')
    @trigger 'modal:closed'
