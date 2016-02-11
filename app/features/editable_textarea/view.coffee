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
              ,
                name: 'readonly'
                observe: 'author_id'
                onGet: (value) ->
                  !can('update', @model)
            ]

    ui:
      editor: 'textarea'

    events:
      'blur @ui.editor': '_save'

    onBeforeRender: ->
      @model = @options.model()
      @listenToOnce @model, 'sync', ->
        @initialValue = @model.get('description')

    onRender: ->
      autosize(@ui.editor)

    onBeforeDestroy: ->
      autosize.destroy(@ui.editor)

    _save: ->
      return if @initialValue is @model.get('description')
      @model.save()
        .then =>
          @initialValue = @model.get('description')
        .fail =>
          @model.set(description: @initialValue)