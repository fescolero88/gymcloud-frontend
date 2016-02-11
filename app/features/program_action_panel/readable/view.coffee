define [
  './template'
  '../model'
], (
  template
  DataModel
) ->

  class View extends Marionette.LayoutView

    template: template

    className: 'program-action-panel'

    behaviors:

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
          'button':
            observe: 'person_id'
            visible: (value) ->
              can('update', @model)

    events:
      'click button': '_onEdit'

    initialize: ->
      @data = new DataModel
      @listenTo @model, 'change:person_id', =>
        @data.set(person_id: @model.get('person_id'))
      @listenTo @model.weeks, 'reset add remove', =>
        @data.set(weeksCount: @model.weeks.length)
      @listenTo @model.workouts, 'reset add remove', =>
        @data.set(workoutsCount: @model.workouts.length)

    _onEdit: ->
      App.request 'modal:confirm',
        title: "Edit #{@model.get('name')}?"
        content: "Use it to adjust specific client's program."
        confirmBtn: 'Update'
        confirmCallBack: =>
          path = "#personal_programs/#{@model.id}/edit"
          App.vent.trigger('redirect:to', path, replace: false)
