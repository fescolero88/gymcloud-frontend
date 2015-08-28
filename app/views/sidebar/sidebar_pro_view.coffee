define [
  'backbone.marionette'
  'collections/user_collection'
  'views/sidebar/template_collection_view'
  'templates/sidebar/sidebar_pro_section'
], (
  Marionette
  UserCollection
  TemplateCollectionView
  template
)->
  class SidebarProView extends Marionette.LayoutView

    template: template

    className: 'gc-scrollable-area'

    events:
      'click @ui.item': 'toggleItem'

    ui:
      subs: '.gc-sidebar-folder>.gc-sidebar-sub, .gc-sidebar-cat>.gc-sidebar-sub'
      catchList: '.gc-assign-catch'
      item: '.gc-sidebar-item > a'
      exercisesRegion: 'region[data-name="exercises"]'
      workoutsRegion: 'region[data-name="workout_templates"]'
      programsRegion: 'region[data-name="program_templates"]'

    regions:
      exercises: '@ui.exercisesRegion'
      workout_templates: '@ui.workoutsRegion'
      program_templates: '@ui.programsRegion'

    initialize: ->
      App.vent.on 'profile:ready', @initializeProSidebar

    onDestroy: ->
      App.vent.off 'profile:ready', @initializeProSidebar

    initializeProSidebar: =>
      typeByName = (name) ->
        {
          Exercises: 'exercises'
          Workouts: 'workout_templates'
          Programs: 'program_templates'
        }[name]

      library = new UserCollection([], type: 'library')
      library.fetch().then =>
        root = library.models[0]
        _.each root.get('items'), (folder) =>
          type = typeByName(folder.name)
          App.request("data:#{type}:reset", folder.items)
          collection = new UserCollection(folder.items, type)
          view = new TemplateCollectionView
            collection: collection
            type: type
            name: folder.name
          @getRegion(type).show(view)
          # @initDragAndDrop()

    onRender: ->


    toggleItem: (ev) ->
      activeItem = @el.querySelector('.gc-sidebar-item > a.active')
      activeItem.classList.remove('active') if activeItem

      ev.currentTarget.classList.add 'active'

    initDragAndDrop: () ->
      @ui.subs.sortable
        group: 'assignEx'
        drop: false
        handle: '.draggable-handle'
        containerSelector: '.gc-sidebar-sub'
        placeholder: '<div class="placeholder sortable-placeholder"/>'
        itemSelector: '.gc-sidebar-item'
        onDragStart: ($item, container, _super, e) =>
          @ui.catchList.children().remove()
          $item.css
            height: $item.height()
            width: $item.width()
          $item.addClass('dragged')
            .data 'category', $item.closest('.gc-sidebar-cat').data 'category'
            .parents('.gc-sidebar-sub').css 'overflow', 'visible'
          $('body').addClass('dragging')
          if not container.options.drop
            $item.clone()
              .insertAfter($item)
              .removeClass('dragged')
              .removeAttr('style')
          _super $item, container
          App.vent.trigger 'drag:start'
        onDrop: ($item, container, _super, e) ->
          $item.removeClass('dragged').removeAttr('style')
          subs.removeAttr('style')
          $('body').removeClass('dragging')
          draggable = new DraggableMenuItemModel
            id: $item.find('[data-key]').data('key')
            name: $item.find('[data-key]').text()
            category: $item.data 'category'
          App.vent.trigger 'drag:drop', draggable, e

      $('.gc-assign-catch').sortable
        drag: false
        group: 'assignEx'
