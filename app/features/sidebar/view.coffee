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
      workoutExercises: 'region[data-name="workout_exercises"]'
      personalWorkoutsRegion: 'region[data-name="personal_workouts"]'
      personalProgramsRegion: 'region[data-name="personal_programs"]'

    regions:
      pro: '@ui.proRegion'
      workoutExercises: '@ui.workoutExercises'
      personalWorkouts: '@ui.personalWorkoutsRegion'
      personalPrograms: '@ui.personalProgramsRegion'

    templateHelpers: ->
      isPro: @currentUser.get('is_pro')

    initialize: ->
      @currentUser = App.request('current_user')

    renderPersonalEntities: ->
      items = ['workout_exercises', 'personal_workouts', 'personal_programs']
      _.each items, (item) =>
        view = new PersonalCollectionView
          collection: @currentUser[item]
          type: item

        regionName = _.camelCase(item)
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