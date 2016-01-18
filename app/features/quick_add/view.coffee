define [
  './template'
  './model'
], (
  template
  Model
) ->

  class View extends Marionette.ItemView

    template: template

    ui:
      'button': 'button'
      'inputWrapper': '.gc-exercises-assign-input-wrapper'

    events: ->
      'click @ui.button': =>
        @model.set('state', 'autocomplete')
        @$el.find('.selectize-input input').focus()
      'blur @ui.inputWrapper': =>
        @model.set('state', 'button')

    behaviors: ->

      stickit:
        bindings:
          'button':
            observe: 'state'
            visible: (value) ->
              value is 'button'
          'button span span':
            observe: 'modelName'
            onGet: (value) ->
              "Add #{value}"
          '.gc-exercises-assign-input-wrapper':
            observe: 'state'
            visible: (value) ->
              value is 'autocomplete'
          '.gc-exercises-assign-input':
            attributes: [
                name: 'placeholder'
                observe: 'modelName'
                onGet: (value) ->
                  name = _.chain(value)
                    .humanize()
                    .pluralize()
                    .value()
                  "Search #{name}"
            ]
      auto_complete:
        onItemAdd: ((view) ->
          (value, $item) ->
            @clear()
            view.trigger('quick_add:chosen', value, $item)
        )(@)
        collection: ((view) ->
          result = view.options.collection
            .map (item) ->
              folder: false
              id: item.get('id')
              name: item.get('name')
              sort_id: "~-2-#{_.underscore(item.get('name'))}"
          type = _.humanize(view.options.collection.model.prototype.type)
          result.unshift
            id: 0
            name: "CREATE NEW #{type}"
            icon: 'gc-icon-exercises-add'
            sort_id: '~-1-sort'
          result
        )(@)

    constructor: ->
      @model = new Model
      super
      @model.set('modelName', @options.typeToAdd)

    initialize: ->
      @listenTo @, 'quick_add:chosen', =>
        @ui.inputWrapper.trigger('blur')
