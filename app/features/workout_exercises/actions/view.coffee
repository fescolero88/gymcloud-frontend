define [
  './template'
  'features/quick_add/view'
  'features/exercise_properties/multi_constructor/view'
], (
  template
  QuickAddView
  ExercisePropertiesMultiConstructor
) ->

  class View extends Marionette.LayoutView

    template: template

    behaviors: ->

      regioned:
        views: [
            region: 'quick_add'
            klass: QuickAddView
            options: -> {}
            enabled: ->
              can('update', @model)
          ,
            region: 'exercise_properties_multi_construtor'
            klass: ExercisePropertiesMultiConstructor
            options: -> {}
        ]

    onShow: ->
      @listenTo @views.quick_add, 'quick_add:chosen', (id) =>
        @trigger('actions:add', id)
      App.request 'fwd',
        context: @
        from: @views.exercise_properties_multi_construtor
        to: @
        prefix: 'actions'
        events: [
          'multi_constructor:start'
          'multi_constructor:stop'
          'multi_constructor:assign'
        ]
