define [
  'backbone.marionette'
  './overview/view'
  'views/trainer/workouts/workout_global_video_view'
  './assignment/view'
  'models/workout_exercise'
  './template'
], (
  Marionette
  WorkoutGlobalOverviewView
  WorkoutGlobalVideoView
  WorkoutGlobalAssignView
  WorkoutExercise
  template
) ->
  class WorkoutConstructorView extends Marionette.LayoutView

    template: template

    regions:
      manageRegion: '#workout-manage'

    ui:
      workoutTitle: '.gc-workout-title span'
      innerNav: '.gc-inner-nav'
      innerNavItems: '.gc-inner-nav li'
      innerNavLinks: '.gc-inner-nav li a'
      contentNavItems: '.gc-content-nav li'
      contentNavLinks: '.gc-content-nav li a'
      navBack: '.gc-content-nav-back'
      addToLibraryButton: '.gc-add-to-library-button'
      addNoteButton: '.gc-workout-add-note'

    events:
      'click @ui.navBack': 'navigateBack'
      'click @ui.innerNavLinks': 'changeOverviewActiveTab'
      'blur @ui.workoutTitle': 'workoutTitleSave'
      'click @ui.addToLibraryButton': 'showAddToLibrary'
      'click @ui.contentNavLinks': 'changeActiveTab'
      'click @ui.addNoteButton': 'triggerAddNote'
      'keypress @ui.workoutTitle': 'saveTitleOnEnter'

    bindings:
      '.gc-workout-title span': 'name'

    templateHelpers: =>
      isAuthor: do =>
        App.request('current_user_id') == @model.get('id')

    initialize: (data) =>
      @isDroppable = true

      App.vent.on 'drag:complete', @assignExercise
      App.vent.on 'workout:add:exercise', @assignExercise

      @workoutExerciseModel = new WorkoutExercise
      @listenTo(@workoutExerciseModel, 'sync', @onExerciseAdded)

    onDestroy: ->
      @unstickit()
      App.vent.off 'drag:complete', @assignExercise
      App.vent.off 'workout:add:exercise', @assignExercise

    onShow: ->
      _.extend(this.constructor.prototype, Backbone.Stickit.ViewMixin)
      @stickit()
      @changeView 'description'

    navigateBack: ->
      window.history.back()

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
          Klass = WorkoutGlobalOverviewView
          @ui.innerNav.show()
        when 'video'
          Klass = WorkoutGlobalVideoView
          @ui.innerNav.show()
        when 'assign'
          Klass = WorkoutGlobalAssignView
          @ui.innerNav.hide()
      view = new Klass(model: @model)
      @getRegion('manageRegion').show(view)

    workoutTitleSave: =>
      if @model.hasChanged()
        @model.save().success ->
          App.request 'messenger:show',
            hideAfter: 5
            message: "Workout's title saved."
            type: 'success'

    showAddToLibrary: (ev) =>
      ev.preventDefault()
      App.vent.trigger 'base:addToLibraryModal', type: 'workouts', model: @model

    assignExercise: (item) =>
      if item instanceof Backbone.Model
        item = item.toJSON()

      if item.category == 'exercises'
        workout_exercise = new WorkoutExercise
          exercise_id: item.id
          workout_id: @model.id
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

    saveTitleOnEnter: (ev) ->
      if ev.which in [13, 27]
        ev.preventDefault()
        @ui.workoutTitle.blur()
