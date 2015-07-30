Marionette = require 'backbone.marionette'
PropertyCollection = require 'models/trainer/property-collection'
_ = require 'underscore'

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

  ui:
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
    #'blur @ui.selectedPropertyValue': 'saveProperty'
    'keypress @ui.selectedPropertyValue': 'saveOnEnter'
    'click @ui.toggleEditMode': 'toggleEditMode'

  modelEvents:
    sync: 'onSync'

  initialize: (options) ->
    @properties = []
    @selectedPropertyId = ''
    @sameControl = false
    @model.set 'property_value', @model.get('value')
    @model.set 'property_name', @model.get('name')
    @state = @model.get('state') || 'view'
    @collection = new PropertyCollection()
    @collection.fetch().then =>
      @render()

  onRender: ->
    #set default property id
    if @model.isNew()
      @model.set 'property_id', @properties[0]?.id
      #@model.set 'property_value', @properties[0]?.defaultvalue
      @ui.selectedPropertyValue.focus()
      @model.set 'property_name', @properties[0]?.name

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
    @model.get('state', 'edit')
    @ui.selectedPropertyLabel.html @model.get('property_name')
    @ui.selectedPropertyValue.html @model.get('property_value')
    @ui.editPropertyControl.removeClass 'hidden'
    @ui.viewPropertyControl.addClass 'hidden'
    @ui.selectedPropertyValue.focus()

  saveOnEnter: (e) ->
    if e.which is 13
      e.preventDefault()
      @saveProperty(e)

  saveProperty: (e) ->
    @model.set 'property_value', e.target.innerHTML
    @model.save()
    @model.set 'state', 'view'

  saveOnBlur: (ev) ->
    if $(':focus').parent(@ui.editPropertyControl).length is 0
      @model.set 'property_value', @ui.selectedPropertyValue.text()
      @model.save().then =>
        @model.set 'state', 'view'

  onSync: =>
    @ui.propertyValueNameLabel.html "#{@model.get 'property_value'} #{@model.get 'property_name'}"
    @ui.editPropertyControl.addClass 'hidden'
    @ui.viewPropertyControl.removeClass 'hidden'
