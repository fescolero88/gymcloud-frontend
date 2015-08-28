Marionette = require 'backbone.marionette'
Backbone = require 'backbone'
DraggableMenuItem = require 'models/draggable_menu_item'
SidebarEntity = require 'views/trainer/sidebar-entity-composite-view'
SidebarItems = require 'collections/sidebar_items'

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
    App.vent.on 'ewp:model:updated', @updateEWPName
    App.vent.on 'profile:ready', @getData

  onDestroy: ->
    App.vent.off 'ewp:model:updated', @updateEWPName

  onShow: ->
    #@getData()

  onRender: ->
    @$el.find('.nano').nanoScroller()

    _.each ['exercises', 'workouts', 'programs'], (item) =>
      view = new SidebarEntity
        type: item
        collection: new SidebarItems App.request("data:#{item}")
      @getRegion(item).show(view)

  toggleMenu: (ev) ->
    target = $(ev.target)
    currentTarget = $(ev.currentTarget)
    if target.hasClass('toggle-it') or currentTarget.hasClass('toggle-it')
      ev.preventDefault()
      currentTarget.toggleClass('active')

  toggleItem: (ev) ->
    activeItem = @el.querySelector('.gc-sidebar-item > a.active')
    activeItem.classList.remove('active') if activeItem

    ev.currentTarget.classList.add 'active'

  onClickSidebar: (ev) ->
    #for catching of menu slide transition time 0.5s
    setTimeout =>
      @$el.find('.nano').nanoScroller()
    , 600

  getData: =>
    userId = App.request('data:profile').get('id')
    library = $.ajax
      url: "/users/#{userId}/collections/library"
      type: 'GET'
      dataType: 'json'
      success: (data) ->
        for item in data[0].items
          entity = item.name.toLocaleLowerCase()
          App.request("data:#{entity}:reset", item.items)
          App.request("data:#{entity}:root:reset", item.key)
        App.vent.trigger('assignments:loaded')

    properties = $.get("/users/#{userId}/collections/personal_properties").then (data) ->
      App.request('data:properties:reset', data)

    $.when.apply($,[library, properties]).done () =>
      @render()
      @initDragAndDrop()

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
        draggable = new DraggableMenuItem
          id: $item.find('[data-key]').data('key')
          name: $item.find('[data-key]').text()
          category: $item.data 'category'
        App.vent.trigger 'drag:drop', draggable, e

    $('.gc-assign-catch').sortable
      drag: false
      group: 'assignEx'

  updateEWPName: (type, key, newValue) -> # todo implement for programs
    selector = "span[data-key=\"#{key}\"]"
    @ui["#{type}Region"].find(selector).html(newValue)
