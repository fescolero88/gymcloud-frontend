define [
  './template'
  './personal/view'
  './pro/view'
], (
  template
  PersonalCollectionView
  SidebarProView
)->

  class SidebarView extends Marionette.LayoutView

    template: template

    className: 'gc-scrollable-area'

    ui:
      item: '.gc-sidebar-item > a'

    events:
      'click .toggle-menu': 'toggleMenu'
      'click @ui.item': 'toggleItem'
      'click .nano': 'onClickSidebar'

    behaviors:

      regioned:
        views: [
            region: 'pro'
            klass: SidebarProView
            options: -> {}
            enabled: ->
              @user.get('is_pro')
          ,
            region: 'workout_exercises'
            klass: PersonalCollectionView
            options: ->
              collection: @user.workout_exercises
              type: 'workout_exercises'
            enabled: ->
              not @user.get('is_pro')
          ,
            region: 'personal_workouts'
            klass: PersonalCollectionView
            options: ->
              collection: @user.personal_workouts
              type: 'personal_workouts'
            enabled: ->
              not @user.get('is_pro')
          ,
            region: 'personal_programs'
            klass: PersonalCollectionView
            options: ->
              collection: @user.personal_programs
              type: 'personal_programs'
            enabled: ->
              not @user.get('is_pro')
        ]

    initialize: ->
      @user = App.request('current_user')

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
      setTimeout =>
        @$el.find('.nano').nanoScroller()
      , 600
