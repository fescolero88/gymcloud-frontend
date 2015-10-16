define [
  'models/draggable_menu_item'
  'collections/sidebar_items'
  './personal/view'
  './pro/view'
  './template'
], (
  DraggableMenuItemModel
  SidebarItemsCollection
  PersonalCollectionView
  SidebarProView
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
      proRegion: 'pro-section'
      personalWorkoutsRegion: 'region[data-name="personal_workouts"]'
      personalProgramsRegion: 'region[data-name="personal_programs"]'

    regions:
      pro: '@ui.proRegion'
      personalWorkouts: '@ui.personalWorkoutsRegion'
      personalPrograms: '@ui.personalProgramsRegion'

    templateHelpers: ->
      isPro: @currentUser.get('is_pro')

    initialize: ->
      @currentUser = App.request('current_user')

    renderPersonalEntities: ->
      _.each ['workouts', 'programs'], (item) =>
        view = new PersonalCollectionView
          collection: @currentUser["personal_#{item}"]
          type: item

        regionName = "personal#{_.capitalize(item)}"
        @getRegion(regionName).show(view)

    onRender: ->
      if @currentUser.get('is_pro')
        @getRegion('pro').show(new SidebarProView)
      else
        @renderPersonalEntities()

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
