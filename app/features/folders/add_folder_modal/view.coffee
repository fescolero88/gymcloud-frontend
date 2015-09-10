define [
  'models/folder'
  'views/helpers/form-validation-behaviour'
  './template'
], (
  Folder
  FormValidationBehaviour
  template
) ->

  class AddFolderModalView extends Marionette.ItemView

    template: template

    className: 'modal-dialog modal-md'

    behaviors:
      FormValidationBehaviour:
        behaviorClass: FormValidationBehaviour

    ui:
      form: 'form'

    events:
      'submit @ui.form': 'submitForm'

    bindings:
      '[data-bind="name"]': 'name'

    initialize: (data) =>
      @parent = data.parent
      @model = new Folder
        parent_id: @parent.get('id')

    onRender: ->
      @stickit()

    onDestroy: ->
      @unstickit()

    submitForm: (ev) ->
      ev.preventDefault()
      @model.save().then =>
        user = App.request('current_user')
        folders = user.folders
        folders.add(@model)
        @parent.items.unshift(@model)
        @$el.parent().modal 'hide'
        @_showSuccessMessage()

    _showSuccessMessage: ->
      App.request 'messenger:show',
        hideAfter: 5
        message: "New folder added"
        type: 'success'
