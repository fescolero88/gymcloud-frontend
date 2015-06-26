Marionette = require 'backbone.marionette'
DraggableMenuItemModel = require 'models/trainer/draggable-menuitem-model'

module.exports = class SideBarView extends Marionette.ItemView

  template: require('templates/trainer/sidebar/sidebar')

  className: 'gc-scrollable-area'

  events:
    'click .toggle-menu': 'toggleMenu'
    'click @ui.item': 'toggleItem'
    'click .nano': 'onClickSidebar'

  ui:
    subs: '.gc-sidebar-folder > .gc-sidebar-sub, .gc-sidebar-cat > .gc-sidebar-sub'
    sidebar: '.gc-sidebar-menu-list'
    dndArea: '.gc-dnd-area'
    mainArea: '.gc-main'
    catchList: '.gc-assign-catch'
    item: '.gc-sidebar-item > a'

  initialize: =>
    @exercises = []
    @workouts = []
    @programs = []
    @clients = []
    @groups = []
    App.vent.on 'profile:ready', =>
      @getData()

  onShow: ->
    @getData()

  onRender: ->
    @$el.find('.nano').nanoScroller()

  templateHelpers: =>
    exercises: => App.request 'data:exercises'
    workouts: => App.request 'data:workouts'
    programs: => App.request 'data:programs'

  toggleMenu: (ev) ->
    if $(ev.target).hasClass('toggle-it') or $(ev.currentTarget).hasClass('toggle-it')
      ev.preventDefault()
      $(ev.currentTarget).toggleClass('active')

  toggleItem: (ev) ->
    activeItem = @el.querySelector '.gc-sidebar-item > a.active'
    if activeItem
      activeItem.classList.remove 'active'

    ev.currentTarget.classList.add 'active'

  onClickSidebar: (ev) ->
    #for catching of menu slide transition time 0.5s
    setTimeout =>
      @$el.find('.nano').nanoScroller()
    , 600


  getData: =>
    if !App.request 'data:exercises'
      $.ajax
        url: '/api/mobile/library/'
        type: 'GET'
        dataType: 'json'
        success: (data) =>
          for item in data
            switch item.title
              when 'Exercises'
                App.request 'data:exercises:reset', item.items
                App.request 'data:exercises:root:reset', item.key
              when 'Workouts'
                App.request 'data:workouts:reset', item.items
                App.request 'data:workouts:root:reset', item.key
              when 'Programs'
                App.request 'data:programs:reset', item.items
                App.request 'data:programs:root:reset', item.key
          window.App.vent.trigger 'assignments:loaded'
          @render()
          @initDragAndDrop()

  initDragAndDrop: () =>
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
        _super $item
        App.vent.trigger 'drag:start'
      onDrop: ($item, container, _super, e) =>
        $item.removeClass('dragged').removeAttr('style')
        @ui.subs.removeAttr('style')
        $('body').removeClass('dragging')
        draggable = new DraggableMenuItemModel
          id: $item.find('[data-key]').data('key')
          name: $item.find('[data-key]').text()
          category: $item.data 'category'
        App.vent.trigger 'drag:drop', draggable, e

    $('.gc-assign-catch').sortable
      drag: false
      group: 'assignEx'
