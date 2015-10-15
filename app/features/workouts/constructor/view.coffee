define [
  'features/breadcrumbs/view'
  './overview/view'
  'features/video_assignment/view'
  'features/assignment_list/view'
  'models/workout_exercise'
  './template'
], (
  Breadcrumbs
  OverviewView
  VideoAssignmentView
  AssignView
  WorkoutExercise
  template
) ->
  class WorkoutConstructorView extends Marionette.LayoutView

    template: template

    regions:
      manage: 'region[data-name="workout-manage"]'
      breadcrumbs: 'region[data-name="breadcrumbs"]'

    ui:
      innerNav: '.gc-inner-nav'
      innerNavItems: '.gc-workout-nav li'
      innerNavLinks: '.gc-workout-nav li a'
      addToLibraryButton: '.gc-add-to-library-button'
      addNoteButton: '.gc-workout-add-note'

    events:
      'click @ui.innerNavLinks': 'changeViewEvent'
      'click @ui.addToLibraryButton': 'showAddToLibrary'
      'click @ui.addNoteButton': 'triggerAddNote'

    behaviors:
      navigate_back: true

      stickit:
        bindings:
          '.gc-workout-title span': 'name'

    modelEvents:
      sync: '_onSync'
      error: '_onSyncError'
      'change:video_url': '_videoAssigned'

    templateHelpers: =>
      author: @model.author.toJSON()
      isAuthor: do =>
        App.request('current_user_id') == @model.get('author_id')

    initialize: (data) =>
      @isDroppable = true
      @breadcrumbs = new Breadcrumbs(model: @model)
      App.vent.on 'drag:complete', @assignExercise
      App.vent.on 'workout:add:exercise', @assignExercise

      @workoutExerciseModel = new WorkoutExercise
      @listenTo(@workoutExerciseModel, 'sync', @onExerciseAdded)

    onRender: ->
      view = new OverviewView(model: @model)
      @getRegion('manage').show(view)
      @getRegion('breadcrumbs').show(@breadcrumbs)

    onDestroy: ->
      App.vent.off 'drag:complete', @assignExercise
      App.vent.off 'workout:add:exercise', @assignExercise

    changeViewEvent: (ev, ui) =>
      ev.preventDefault()
      navItem = $(ev.currentTarget).parent()
      navItemView = $(navItem).data('view')
      @_changeView(navItemView)

    _changeView: (name) ->
      navItem = @ui.innerNavItems.filter("[data-view='#{name}']")

      unless navItem.hasClass('active')
        @ui.innerNavItems.removeClass('active')
        navItem.addClass('active')
        @_renderView(name)

    _renderView: (navView) =>
      View = {
        overview: OverviewView
        video: VideoAssignmentView
        assign: AssignView
      }[navView] || OverviewView
      view = new View(model: @model)
      @getRegion('manage').show(view)

    showAddToLibrary: (ev) =>
      ev.preventDefault()
      App.vent.trigger 'base:addToLibraryModal', type: 'workouts', model: @model

    assignExercise: (item) =>
      if item instanceof Backbone.Model
        item = item.toJSON()

      if item.category == 'exercises'
        position = @model.exercises.length + 1
        workout_exercise = new WorkoutExercise
          exercise_id: item.id
          workout_id: @model.id
          order_name: position
          position: position
        workout_exercise.save().then =>
          @model.exercises.add(workout_exercise)

    onExerciseAdded: () =>
      App.request 'messenger:show',
        hideAfter: 5
        message: 'Exercise Added.'
        type: 'success'
      @model.fetch()

    triggerAddNote: ->
      App.vent.trigger 'workout:notes:add'

    _onSync: (_model, response, options) ->
      funcName = {PATCH: '_onSyncUpdate'}[options.type] || '_onDestroy'

      this[funcName](response)

    _onSyncUpdate: (_response) ->
      App.request 'messenger:show',
        hideAfter: 5
        message: "Workout Updated."
        type: 'success'

    _onSyncError: (_response) ->
      App.request('messenger:show', message: 'Oops. Something went wrong')

    _onDestroy: (response) ->
      url = "#workout_templates_folder/#{response.folder_id}"
      Backbone.history.navigate(url, {trigger:true, replace: true})
      App.request('messenger:show', message: 'Workout removed from library')

    _videoAssigned: ->
      @_changeView('overview')