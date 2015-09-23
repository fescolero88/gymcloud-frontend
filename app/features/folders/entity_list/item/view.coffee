define [
  './template'
], (
  template
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
          '[data-bind="name"]': 'name'
          '[data-bind="updated_at"]': 'updated_at'
          ':el':
            observe: ['folder_id', 'id']
            update: ($el, _val, model, _options) ->
              $el.attr('data-id', model.get('id'))
              if model.get('folder_id')
                $el.addClass('gc-folder-item')
              else
                $el.addClass('gc-folder')

    initialize: (options) =>
      @type = options.type
      @dragula = options.dragula

    templateHelpers: ->
      type: @type
      isFolder: !@model.get('folder_id')
      url: do =>
        if @model.get('folder_id')
          "##{@type}/#{@model.get('id')}"
        else
          "##{@type}_folder/#{@model.get('id')}"

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