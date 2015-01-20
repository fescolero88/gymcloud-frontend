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

    @getData().then =>
      @initDragAndDrop()

  templateHelpers: =>
    exercises: => window.App.exercises
    workouts: => window.App.workouts
    programs: => window.App.programs

  toggleMenu: (ev) ->
    if not $(ev.target).hasClass 'gc-sidebar-cat-name'
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
            when "Exercises" then window.App.exercises = item.items
            when "Workouts" then window.App.workouts = item.items
            when "Programs" then window.App.programs = item.items
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
          key: $item.find('[data-key]').data('key')
          category: $item.data 'category'
        App.vent.trigger 'drag:drop', draggable, e

    $('.gc-assign-catch').sortable
      drag: false
      group: 'assignEx'
