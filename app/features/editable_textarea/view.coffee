define [
  './template'
  'autosize'
], (
  template
  autosize
) ->

  class View extends Marionette.ItemView

    template: template

    className: 'gc-editable-textarea form-group'

    behaviors:

      stickit:
        bindings: ->
          '.content':
            observe: 'description'
            updateModel: false
          'textarea':
            observe: 'description'
            afterUpdate: ->
              @_updateAutosizeDelayed()
            attributes: [
                name: 'placeholder'
                observe: 'description'
                onGet: (value) ->
                  'Start typing a description here...'
              ,
                name: 'readonly'
                observe: ['author_id', 'person_id']
                onGet: (values) ->
                  !can('update', @model)
            ]
            classes:
              'empty':
                observe: 'description'
                onGet: (value) ->
                  "#{value}".length is 0

    ui:
      editor: 'textarea'

    events:
      'blur @ui.editor': '_save'

    initialize: ->
      @_updateAutosizeDelayed = _.debounce(@_updateAutosize, 200)

    onBeforeRender: ->
      @model = @options.model()
      @listenToOnce @model, 'sync', ->
        @initialValue = @model.get('description')

    onShow: ->
      @_updateAutosizeDelayed()

    onBeforeDestroy: ->
      autosize.destroy(@ui.editor)

    _save: ->
      return if @initialValue is @model.get('description')
      @model.save()
        .then =>
          @initialValue = @model.get('description')
        .fail =>
          @model.set(description: @initialValue)

    _updateAutosize: ->
      autosize(@ui.editor)
