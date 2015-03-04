Marionette = require 'backbone.marionette'

DraggableMenuItemModel = require 'models/trainer/draggable-menuitem-model'

module.exports = class SideBarView extends Marionette.ItemView

  template: Templates.trainer.sidebar.sidebar

  events:
    "click .toggle-menu": "toggleMenu"

  ui:
    subs: ".gc-sidebar-folder > .gc-sidebar-sub, .gc-sidebar-cat > .gc-sidebar-sub"
    sidebar: ".gc-sidebar-menu-list"
    dndArea: ".gc-dnd-area"
    mainArea: ".gc-main"
    catchList: ".gc-assign-catch"

  initialize: =>
    @exercises = []
    @workouts = []
    @programs = []
    @clients = []
    @groups = []

  onShow: ->
    @getData().then =>
      @initDragAndDrop()

  templateHelpers: =>
    exercises: => App.request 'data:exercises'
    workouts: => App.request 'data:workouts'
    programs: => App.request 'data:programs'

  toggleMenu: (ev) ->
    if $(ev.target).hasClass('toggle-it') or $(ev.currentTarget).hasClass('toggle-it')
      ev.preventDefault()
      $(ev.currentTarget).toggleClass('active')

  getData: =>
    $.ajax
      url: '/api/mobile/library/'
      type: 'GET'
      dataType: 'json'
      success: (data) =>
        for item in data
          switch item.title
            when "Exercises" then App.request 'data:exercises:reset', item.items
            when "Workouts" then App.request 'data:workouts:reset', item.items
            when "Programs" then App.request 'data:programs:reset', item.items
        window.App.vent.trigger 'assignments:loaded'
        @render()

  initDragAndDrop: () =>
    @ui.subs.sortable
      group: 'assignEx'
      drop: false
      handle: '.glyphicon'
      containerSelector: '.gc-sidebar-sub'
      placeholder: '<div class="placeholder sortable-placeholder"/>'
      itemSelector: '.gc-sidebar-item'
      onDragStart: ($item, container, _super, e) =>
        @ui.catchList.children().remove()
        $item.css
          height: $item.height()
          width: $item.width()
        $item.addClass("dragged")
          .data 'category', $item.closest('.gc-sidebar-cat').data 'category'
          .parents('.gc-sidebar-sub').css 'overflow', 'visible'
        $("body").addClass("dragging")
        if not container.options.drop
          $item.clone()
            .insertAfter($item)
            .removeClass('dragged')
            .removeAttr("style")
        _super $item
        App.vent.trigger 'drag:start'
      onDrop: ($item, container, _super, e) =>
        $item.removeClass("dragged").removeAttr("style")
        @ui.subs.removeAttr("style")
        $("body").removeClass("dragging")
        draggable = new DraggableMenuItemModel
          id: $item.find('[data-key]').data('key')
          name: $item.find('[data-key]').text()
          category: $item.data 'category'
        App.vent.trigger 'drag:drop', draggable, e

    $('.gc-assign-catch').sortable
      drag: false
      group: 'assignEx'
