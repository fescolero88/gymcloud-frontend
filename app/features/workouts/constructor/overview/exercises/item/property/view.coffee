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
      savePropertyButton: '.gc-save'

    events: ->
      'click @ui.removePropertyButton': 'removeProperty'
      'click @ui.propertyItem': 'selectProperty'
      'focusout @ui.editPropertyControl':  _.debounce(@saveOnBlur, 200)
      'keypress @ui.selectedPropertyValue': 'saveOnEnter'
      'click @ui.savePropertyButton': 'saveProperty'
      'click @ui.toggleEditMode': '_toggleEditMode'

    modelEvents:
      sync: 'onSync'

    initialize: (options) ->
      @properties = options.properties
      @state = @model.get('state') || 'view'
      currentUser = App.request('current_user')
      @collection = currentUser.personal_properties

    onRender: ->
      if @model.isNew()
        @toggleEditMode()
        setTimeout =>
          @ui.selectedPropertyValue.focus()
        , 200

    removeProperty: (ev) ->
      ev.stopImmediatePropagation()
      ev.preventDefault()
      @model.destroy()

    selectProperty: (ev) ->
      @ui.selectedPropertyLabel.html(ev.currentTarget.innerHTML)
      @model.set(personal_property_id: ev.target.dataset.id)
      @ui.selectedPropertyValue.focus()

    _toggleEditMode: (e) ->
      @toggleEditMode()

    toggleEditMode: ->
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
      value = parseInt @ui.selectedPropertyValue.text()
      if @model.get('value') != value
        @model.save(value: value, wait: true).then ->
          App.request 'messenger:show',
            type: 'success'
            message: 'Exercise was updated'
            # App.commands.execute 'workout_exercises:property:added
        .fail ->
          App.request 'messenger:show',
            type: 'error',
            message: 'Something went wrong'
      else
        @_toggleViewMode()

      @model.set 'state', 'view'

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
      @_toggleViewMode()
    
    _toggleViewMode: ->
      @ui.editPropertyControl.addClass('hidden')
      @ui.viewPropertyControl.removeClass('hidden')
