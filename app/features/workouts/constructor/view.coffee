define [
  'features/breadcrumbs/view'
  './overview/view'
  'views/trainer/workouts/workout_global_video_view'
  'features/assignment_list/view'
  'models/workout_exercise'
  './template'
], (
  Breadcrumbs
  OverviewView
  VideoView
  AssignView
  WorkoutExercise
  template
) ->
  class WorkoutConstructorView extends Marionette.LayoutView

    template: template

    regions:
      manageRegion: '#workout-manage'
      breadcrumbs: 'region[data-name="breadcrumbs"]'

    ui:
      innerNav: '.gc-inner-nav'
      innerNavItems: '.gc-inner-nav li'
      innerNavLinks: '.gc-inner-nav li a'
      contentNavItems: '.gc-content-nav li'
      contentNavLinks: '.gc-content-nav li a'
      addToLibraryButton: '.gc-add-to-library-button'
      addNoteButton: '.gc-workout-add-note'

    events:
      'click @ui.innerNavLinks': 'changeOverviewActiveTab'
      'click @ui.addToLibraryButton': 'showAddToLibrary'
      'click @ui.contentNavLinks': 'changeActiveTab'
      'click @ui.addNoteButton': 'triggerAddNote'

    behaviors:

      navigate_back: true

      stickit:
        bindings:
          '.gc-workout-title span': 'name'

    modelEvents:
      sync: '_onSync'
      error: '_onSyncError'

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

    onDestroy: ->
      App.vent.off 'drag:complete', @assignExercise
      App.vent.off 'workout:add:exercise', @assignExercise

    onShow: ->
      @getRegion('breadcrumbs').show(@breadcrumbs)
      @changeView 'description'

    changeOverviewActiveTab: (ev) ->
      @changeViewEvent(ev, @ui.innerNavItems)

    changeActiveTab: (ev) ->
      @changeViewEvent(ev, @ui.contentNavItems)

    changeViewEvent: (ev, ui) =>
      ev.preventDefault()
      navItem = $(ev.currentTarget).parent()
      if not $(navItem).hasClass 'active'
        ui.removeClass 'active'
        $(navItem).addClass 'active'
        navItemView = $(navItem).data 'view'
        @changeView navItemView

    changeView: (navView) =>
      switch navView
        when 'description', 'program'
          View = OverviewView
          @ui.innerNav.show()
        when 'video'
          View = VideoView
          @ui.innerNav.show()
        when 'assign'
          View = AssignView
          @ui.innerNav.hide()
      view = new View(model: @model, entityType: 'workout')
      @getRegion('manageRegion').show(view)

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