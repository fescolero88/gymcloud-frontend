define [
  './template'
  'autosize'
], (
  template
  autosize
) ->

  class View extends Marionette.ItemView

    template: template

    className: 'form-group'

    behaviors:

      stickit:
        bindings: ->
          'textarea':
            observe: 'description'
            afterUpdate: ->
              autosize.update(@ui.editor)
            attributes: [
                name: 'placeholder'
                observe: 'description'
                onGet: (value) ->
                  'Start typing a description here...'
            ]

    ui:
      editor: 'textarea'

    events:
      'blur @ui.editor': '_save'

    onBeforeRender: ->
      @model = @options.model()

    onRender: ->
      autosize(@ui.editor)

    onBeforeDestroy: ->
      autosize.destroy(@ui.editor)

    _save: ->
      @model.save()
