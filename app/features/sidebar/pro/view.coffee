define [
  './template'
  'collections/user_collection'
  './root_folders/view'
], (
  template
  UserCollection
  RootFolderView
)->

  class SidebarProView extends Marionette.LayoutView

    template: template

    className: 'gc-scrollable-area'

    events:
      'click @ui.item': 'toggleItem'

    ui:
      subs: '.gc-sidebar-folder > .gc-sidebar-sub, ' +
        '.gc-sidebar-cat > .gc-sidebar-sub'
      catchList: '.gc-assign-catch'
      item: '.gc-sidebar-item > a'
      exercisesRegion: 'region[data-name="exercises"]'
      workoutsRegion: 'region[data-name="workout_templates"]'
      programsRegion: 'region[data-name="program_templates"]'

    regions:
      exercises: '@ui.exercisesRegion'
      workout_templates: '@ui.workoutsRegion'
      program_templates: '@ui.programsRegion'

    onRender: ->
      typeByName = (name) ->
        {
          Exercises: 'exercises'
          Workouts: 'workout_templates'
          Programs: 'program_templates'
        }[name]

      user = App.request('current_user')
      library = user.library

      root = library.models[0]
      root.items.each (folder) =>
        type = typeByName(folder.get('name'))
        # App.request("data:#{type}:reset", folder.items)
        if feature.isEnabled(type)
          view = new RootFolderView
            model: folder
            type: type
          @getRegion(type).show(view)
        # @initDragAndDrop()

    toggleItem: (ev) ->
      activeItem = @el.querySelector('.gc-sidebar-item > a.active')
      activeItem.classList.remove('active') if activeItem

      ev.currentTarget.classList.add 'active'
