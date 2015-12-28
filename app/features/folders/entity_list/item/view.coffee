define [
  './template'
  'moment'
], (
  template
  moment
) ->

  class EntityItemView extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'row'

    ui:
      checkbox: '.gc-exercises-chb input'

    events:
      'click @ui.checkbox': 'itemChecked'

    behaviors:

      stickit:
        bindings:
          ':el':
            attributes: [
              observe: 'id'
              name: 'data-id'
            ]
            classes:
              'gc-folder':
                observe: 'folder_id'
                onGet: (value) ->
                  !value
              'gc-folder-item':
                observe: 'folder_id'
                onGet: (value) ->
                  !!value
          'input':
            observe: 'folder_id'
            updateModel: false
            attributes: [
                'data-id': 'id'
            ]
          '.gc-exercises-folder-icon':
            observe: 'folder_id'
            visible: (value) ->
              !value
          '.gc-exercises-item-icon':
            observe: 'folder_id'
            visible: (value) ->
              !!value
            attributes: [
                name: 'class'
                onGet: (value) ->
                  "gc-exercises-item-icon-#{@type}"
            ]
          '.gc-exercises-link':
            observe: 'name'
            attributes: [
                observe: ['id', 'folder_id']
                name: 'href'
                onGet: (values) ->
                  if values[1]
                    "##{@type}/#{values[0]}"
                  else
                    "##{@type}_folder/#{values[0]}"
              ,
                observe: ['id']
                name: 'data-key'
            ]
          '.gc-exercises-update-time':
            observe: 'updated_at'
            onGet: (value) ->
              moment(value).fromNow()

    initialize: (options) =>
      @type = options.type
      @dragula = options.dragula

    itemChecked: (ev) =>
      @trigger 'item:clicked'

    onShow: ->
      if not @model.get 'folder_id'
        @dragula.containers.push @el
        @dragula.on 'drop', (el, container) =>
          if container is @el
            @triggerMethod 'folder:change', parseInt(el.getAttribute('data-id'))
        @dragula.on 'over', (el, container) ->
          if container and container.classList.contains 'gc-folder'
            container.classList.add 'gc-folder-droppable-state'
        @dragula.on 'out', (el, container) ->
          if container and container.classList.contains 'gc-folder'
            container.classList.remove 'gc-folder-droppable-state'
