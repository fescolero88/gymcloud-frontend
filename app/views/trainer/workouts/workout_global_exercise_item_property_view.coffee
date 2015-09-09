module.exports = class WorkoutGlobalExercisePropertyView extends Marionette.ItemView

  template: require 'templates/trainer/workouts/workout_global_exercise_property'

  tagName: 'li'
  className: 'gc-property-item'

  templateHelpers: ->
    @properties = @collection.toJSON()
    editMode: @state is 'edit'
    properties: @properties
    defaultProperty: @properties[0]?.name
    defaultPropertyValue: @properties[0]?.defaultvalue

  ui: ->
    removePropertyButton: '.gc-remove'
    propertyItem: '.gc-property-item'
    selectedPropertyLabel: '.gc-selected-property'
    selectedPropertyValue: '.gc-property-value'
    propertyValueNameLabel: '.gc-property-value-name-label'
    editPropertyControl: '.gc-property-edit'
    viewPropertyControl: '.gc-property-view'
    toggleEditMode: '.gc-toggle-edit-mode'

  events: ->
    'click @ui.removePropertyButton': 'removeProperty'
    'click @ui.propertyItem': 'selectProperty'
    'focusout @ui.editPropertyControl':  _.debounce(@saveOnBlur, 200)
    'keypress @ui.selectedPropertyValue': 'saveOnEnter'
    'click @ui.toggleEditMode': 'toggleEditMode'

  modelEvents:
    sync: 'onSync'

  initialize: (options) ->
    @properties = []
    @model.set 'property_value', @model.get('value')
    @model.set 'property_name', @model.get('name')
    @state = @model.get('state') || 'view'
    @collection = new Backbone.Collection(App.request('data:properties'))
  
  onRender: ->
    if @model.isNew()
      @model.set 'property_id', @properties[0]?.id
      @model.set 'property_name', @properties[0]?.name
      setTimeout =>
        @ui.selectedPropertyValue.focus()
      , 200

  removeProperty: ->
    @model.destroy()

  selectProperty: (ev) ->
    ev.preventDefault()
    @ui.selectedPropertyLabel.html(ev.currentTarget.innerHTML)
    @model.set 'property_name', ev.target.innerHTML
    @model.set 'property_id', ev.target.dataset.id
    @ui.selectedPropertyValue.focus()

  toggleEditMode: (e) ->
    e.preventDefault()
    @model.set('state', 'edit')
    @ui.selectedPropertyLabel.html @model.get('property_name')
    @ui.selectedPropertyValue.html @model.get('property_value')
    @ui.editPropertyControl.removeClass 'hidden'
    @ui.viewPropertyControl.addClass 'hidden'
    @ui.selectedPropertyValue.focus()

  saveOnEnter: (e) ->
    if e.which is 13
      e.preventDefault()
      @saveProperty()

  saveProperty: ->
    @model.set 'property_value',@ui.selectedPropertyValue.text()
    @model.save().then =>
      App.request 'messenger:show',
        type: 'success'
        message: 'exercise updated'
      @model.set 'state', 'view'
      App.commands.execute 'workout_exercises:property:added'

  saveOnBlur: (ev) ->
    activeEl = $(':focus')
    if @ui.editPropertyControl.find(activeEl).length is 0
      @saveProperty()

  onSync: =>
    @ui.propertyValueNameLabel.html "#{@model.get 'property_value'} #{@model.get 'property_name'}"
    @ui.editPropertyControl.addClass 'hidden'
    @ui.viewPropertyControl.removeClass 'hidden'

