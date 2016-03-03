define [
  './list/view'
  './template'
], (
  AssignedTemplateListView
  template
) ->

  class AssignedTemplatesLayoutView extends Marionette.LayoutView

    template: template

    className: 'gc-exercises-assign'

    behaviors: ->

      stickit:
        bindings:
          'input.gc-exercises-assign-input':
            attributes: [
                name: 'placeholder'
                observe: 'name'
                onGet: (value) ->
                  name = _.humanize(@options.typeName)
                  "Search through assigned #{name}"
            ]

      regioned:
        views: [
            region: 'list'
            klass: AssignedTemplateListView
            options: ->
              collection: @collection
        ]

      auto_complete:
        onItemAdd: ((view) ->
          (id, $item) ->
            @destroy()
            path = "#{view.options.typeName}/#{id}"
            App.vent.trigger('redirect:to', path, replace: false)
        )(@)
        collection: =>
          @collection
        serealizeFn: (item) ->
          folder: item.folder?.name
          id: item.get('id')
          name: item.get('name')
          label: item.get('name')