define [
  './template'
], (
  template
) ->
  class PrivacyButtonsView extends Marionette.ItemView

    template: template

    className: '.btn-group.gc-btn-group gc-exercise-privates'

    attributes: 'data-toggle': 'buttons'

    behaviors:

      stickit:
        bindings:
          '[data-bind="is_public"]':
            observe: 'is_public'
            onSet: '_setPrivacy'

    modelEvents:
      'change:is_public': '_savePrivacy'

    templateHelpers: ->
      isPublic: @isPublic
      isPrivate: not @isPublic

    initialize: ->
      @oldPrivacy = @model.get('is_public')

    _setPrivacy: (value, _options) ->
      value == 'true'

    _savePrivacy: ->
      value = @model.get('is_public')
      if @model.hasChanged('is_public') && value != @oldPrivacy
        @model.save()
          .then => @oldPrivacy = @model.get('is_public')
          .fail => @model.set(is_public: @oldPrivacy)