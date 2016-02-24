define [
  './template'
  './model'
  './user_account_type/view'
], (
  template
  Model
  UserAccountTypeView
) ->

  class PresetLoadModalView extends Marionette.LayoutView

    template: template

    regions:
      modal: 'region[data-name="presets_load_modal"]'

    availableViews:
      user_account_type: UserAccountTypeView

    modelEvents:
      'change:state': @_renderRegionView

    initialize: ->
      @model = new Model

    onRender: ->
      @_renderRegionView(@model.get('state'))

    _renderRegionView: (state) ->
      @stopListening(@view) if @view

      View = @availableViews[state] || @availableViews['user_account_type']
      @view = new View
      @getRegion('modal').show(@view)

      @listenTo(@view, 'changeView', @_changeView)
      @listenTo(@view, 'modal:closed', @_closeModal)

    _changeView: (direction) ->
      states = _.keys(@availableViews)
      index = _.indexOf(states, @model)
      switch direction
        when 'next'
          newState = states[index + 1] || _.last(states)
        when 'prev'
          newState = states[index - 1] || _.first(states)
        else
          # check your direction of the changing view
      @model.set(state: newState)

    _closeModal: ->
      @trigger('modal:closed')
