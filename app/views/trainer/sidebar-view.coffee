Marionette = require 'backbone.marionette'
Backbone = require 'backbone'
DraggableMenuItemModel = require 'models/trainer/draggable-menuitem-model'
SidebarEntity = require 'views/trainer/sidebar-entity-composite-view'
SidebarItemsCollection = require 'models/general/sidebar-items-collection'

module.exports = class SideBarView extends Marionette.LayoutView

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
    exercisesRegion: 'region[data-name="exercises"]'
    workoutsRegion: 'region[data-name="workouts"]'
    programsRegion: 'region[data-name="programs"]'

  regions:
    exercises: '@ui.exercisesRegion'
    workouts: '@ui.workoutsRegion'
    programs: '@ui.programsRegion'

  initialize: =>
    App.vent.on 'profile:ready', @getData
    App.vent.on 'ewp:model:updated', @updateEWPName

  onDestroy: ->
    App.vent.off 'ewp:model:updated', @updateEWPName
    App.vent.off 'profile:ready', @getData

  onRender: ->
    @$el.find('.nano').nanoScroller()

    exercisesView = new SidebarEntity
      type: 'exercises'
      collection: new SidebarItemsCollection App.request('data:exercises')

    workoutsView = new SidebarEntity
      type: 'workouts'
      collection: new SidebarItemsCollection App.request('data:workouts')

    programsView = new SidebarEntity
      type: 'programs'
      collection: new SidebarItemsCollection App.request('data:programs')

    @getRegion('exercises').show(exercisesView)
    @getRegion('workouts').show(workoutsView)
    @getRegion('programs').show(programsView)

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
    subs = @$el.find '.gc-sidebar-folder > .gc-sidebar-sub, .gc-sidebar-cat > .gc-sidebar-sub'
    subs.sortable
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
      onDrop: ($item, container, _super, e) =>
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

  updateEWPName: (type, key, newValue) => # todo implement for programs
    selector = "span[data-key=\"#{key}\"]"
    switch type
      when 'workouts'
        @ui.workoutsRegion.find(selector).html(newValue)
      when 'exercises'
        @ui.exercisesRegion.find(selector).html(newValue)
