define [
  './template'
], (
  template
) ->
  class PropertyView extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'gc-property-item'

    templateHelpers: ->
      editMode: @state is 'edit'
      properties: @properties
      defaultProperty: @properties[0]?.name

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
      @properties = options.properties
      @state = @model.get('state') || 'view'
      currentUser = App.request('current_user')
      @collection = currentUser.personal_properties

    onRender: ->
      if @model.isNew()
        setTimeout =>
          @ui.selectedPropertyValue.focus()
        , 200

    removeProperty: (ev) ->
      ev.stopImmediatePropagation()
      ev.preventDefault();
      @model.destroy()

    selectProperty: (ev) ->
      ev.preventDefault()
      @ui.selectedPropertyLabel.html(ev.currentTarget.innerHTML)
      @model.set(personal_property_id: ev.target.dataset.id)
      @ui.selectedPropertyValue.focus()

    toggleEditMode: (e) ->
      e.preventDefault()
      @model.set('state', 'edit')
      @ui.selectedPropertyLabel.html(@model.get('personal_property').name)
      @ui.selectedPropertyValue.html(@model.get('value'))
      @ui.editPropertyControl.removeClass 'hidden'
      @ui.viewPropertyControl.addClass 'hidden'
      @ui.selectedPropertyValue.focus()

    saveOnEnter: (e) ->
      if e.which is 13
        e.preventDefault()
        @saveProperty()

    saveProperty: ->
      @model.set(value: @ui.selectedPropertyValue.text())
      @model.save().then =>
        App.request 'messenger:show',
          type: 'success'
          message: 'Exercise was updated'
        @model.set 'state', 'view'
        # App.commands.execute 'workout_exercises:property:added'

    saveOnBlur: (ev) ->
      activeEl = $(':focus')
      if @ui.editPropertyControl?.find(activeEl).length is 0
        @saveProperty()

    onSync: =>
      name = @model.get('personal_property').name
      value = @model.get('value')
      unit = @model.get('personal_property').global_property.unit
      label = "#{name}: #{value} #{unit}"
      @ui.propertyValueNameLabel.html(label)
      @ui.editPropertyControl.addClass('hidden')
      @ui.viewPropertyControl.removeClass('hidden')
