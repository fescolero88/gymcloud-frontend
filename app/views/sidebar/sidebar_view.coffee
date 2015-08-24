define [
  'backbone.marionette'
  'models/trainer/draggable-menuitem-model'
  'views/trainer/sidebar-entity-composite-view'
  'models/general/sidebar-items-collection'
  'collections/user_collection'
  'views/sidebar/personal_collection_view'
  'templates/sidebar/sidebar'
], (
  Marionette
  DraggableMenuItemModel
  SidebarEntity
  SidebarItemsCollection
  UserCollection
  PersonalCollectionView
  template
)->
  class SidebarView extends Marionette.LayoutView

    template: template

    className: 'gc-scrollable-area'

    events:
      'click .toggle-menu': 'toggleMenu'
      'click @ui.item': 'toggleItem'
      'click .nano': 'onClickSidebar'

    ui:
      subs: '.gc-sidebar-folder>.gc-sidebar-sub, .gc-sidebar-cat>.gc-sidebar-sub'
      sidebar: '.gc-sidebar-menu-list'
      dndArea: '.gc-dnd-area'
      mainArea: '.gc-main'
      catchList: '.gc-assign-catch'
      item: '.gc-sidebar-item > a'
      exercisesRegion: 'region[data-name="exercises"]'
      workoutsRegion: 'region[data-name="workouts"]'
      programsRegion: 'region[data-name="programs"]'
      personalWorkoutsRegion: 'region[data-name="personal_workouts"]'
      personalProgramsRegion: 'region[data-name="personal_programs"]'

    regions:
      exercises: '@ui.exercisesRegion'
      workouts: '@ui.workoutsRegion'
      programs: '@ui.programsRegion'
      personalWorkouts: '@ui.personalWorkoutsRegion'
      personalPrograms: '@ui.personalProgramsRegion'

    initialize: ->
      _.each ['workouts', 'programs'], (item) =>
        collection = new UserCollection([], type: "personal_#{item}")
        collection.fetch().then =>
          view = new PersonalCollectionView
            collection: collection
            type: item
          regionName = "personal#{_.capitalize(item)}"
          @getRegion(regionName).show(view)

    onRender: ->


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

    # TODO: implement for programs
    # TODO: review and delete
    updateEWPName: (type, key, newValue) ->
      selector = "span[data-key=\"#{key}\"]"
      @ui["#{type}Region"].find(selector).html(newValue)