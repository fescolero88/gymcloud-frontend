define [
  './template'
  './model'
  'features/quick_add/view'
], (
  template
  DataModel
  QuickAddView
) ->

  class View extends Marionette.LayoutView

    template: template

    className: 'program-action-panel row'

    behaviors:
      author_widget: true
      privacy_widget: true

      stickit:
        model: -> @data
        bindings: ->
          highlight = ($el) ->
            $el.addClass('highlight')
            setTimeout (-> $el.removeClass('highlight')), 350

          '.counter.weeks':
            observe: 'weeksCount'
            afterUpdate: highlight
          '.counter.workouts':
            observe: 'workoutsCount'
            afterUpdate: highlight
          '.counters':
            observe: 'state'
            visible: (value) ->
              value isnt 'autocomplete'

      regioned:
        views: [
            region: 'quick_add'
            klass: QuickAddView
            options: ->
              collection: App.request('current_user').workout_templates
              typeToAdd: 'Workout'
        ]

    ui:
      counters: '.counters'
      addWeekBtn: 'button.add-week'
      addWorkoutBtn: 'button.add-workout'

    events:
      'click @ui.addWeekBtn': '_addWeek'
      'click @ui.addWorkoutBtn': '_showAutocomplete'

    initialize: ->
      @data = new DataModel
      @listenTo @model.weeks, 'reset add remove', =>
        @data.set(weeksCount: @model.weeks.length)
      @listenTo @model.workouts, 'reset add remove', =>
        @data.set(workoutsCount: @model.workouts.length)

    onShow: ->
      @listenTo @views.quick_add, 'quick_add:chosen', (id) =>
        @_addWorkoutToCollection(parseInt(id) || undefined)
      @listenTo @views.quick_add.model, 'change:state', (_model, state) =>
        @data.set('state', state)

    _showAutocomplete: ->
      @views.quick_add.trigger('autocomplete')

    _addWorkoutToCollection: (id) ->
      @model.workouts.create
        program_template_id: @model.get('id')
        workout_template_id: id
        position: @model.workouts.length + 1
      ,
        wait: true

    _addWeek: ->
      position = @model.weeks.length + 1
      @model.weeks.create
        program_id: @model.get('id')
        position: position
        name: "Week #{position}"
      ,
        wait: true
