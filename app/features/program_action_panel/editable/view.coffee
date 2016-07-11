define [
  './template'
  '../model'
  'features/quick_add/view'
], (
  template
  DataModel
  QuickAddView
) ->

  class EditableProgramActionPanel extends Marionette.LayoutView

    key: 'EditableProgramActionPanel'

    template: template

    className: 'program-action-panel'

    behaviors: ->
      author_widget:
        enabled: ->
          @view.options.model.type is 'ProgramTemplate'
      privacy_button:
        enabled: ->
          @view.options.model.type is 'ProgramTemplate'

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
          '.back-to-overview':
            observe: 'person_id'
            visible: (value) ->
              @model.type is 'PersonalProgram'
          '.widgets':
            observe: 'position'
            visible: (value) ->
              value is 'top'

      regioned:
        views: [
            region: 'quick_add'
            klass: QuickAddView
            options: ->
              collection: App.request('current_user').workout_templates
              typeToAdd: 'Workout'
              newButtonName: 'Add New'
        ]

    ui:
      counters: '.counters'
      addWeekBtn: 'button.add-week'
      addWorkoutBtn: 'button.add-workout'

    events:
      'click @ui.addWeekBtn': '_addWeek'
      'click @ui.addWorkoutBtn': '_showAutocomplete'
      'click .back-to-overview': '_backToOverview'

    initialize: ->
      @data = new DataModel
        position: @options.position || 'top'
      @listenTo @model, 'change:person_id', =>
        @data.set(person_id: @model.get('person_id'))
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
      position = @_calculatePosition(@model.workouts)
      @model.workouts.create
        program_id: @model.get('id')
        program_type: @model.type
        workout_template_id: id
        position: position
      ,
        wait: true

    _addWeek: ->
      position = @_calculatePosition(@model.weeks)
      @model.weeks.create
        program_id: @model.get('id')
        program_type: @model.type
        position: position
        name: 'Week'
      ,
        wait: true

    _calculatePosition: (collection) ->
      if @data.get('position') is 'bottom'
        lastModelPosition = collection.last()?.get('position') or null
        lastModelPosition + 1
      else
        firstModelPosition = collection.first()?.get('position') or null
        firstModelPosition - 1

    _backToOverview: ->
      path = ['personal_programs', @model.id]
      App.vent.trigger('redirect:to', path, replace: false)
