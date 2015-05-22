Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

module.exports = class LibraryPresetModalView extends Marionette.ItemView

  className: 'modal-dialog'
  
  template: Templates.general.library_preset_modal

  initialize: ->
    @currentIndex = 0

  ui:
    initializePreset: 'a.gc-initialize-preset'
    rejectPreset: 'a.gc-reject-preset'
    presetSteps: '.gc-step'
    savePreset: 'a.gc-save-preset'
    nextButton: 'a.next-button'
    previousButton: 'a.previous-button'

  events:
    'click @ui.nextButton': 'onNext'
    'click @ui.previousButton': 'onPrevious'

  onNext: (ev) ->
    ev.preventDefault()
    @ui.presetSteps[@currentIndex].classList.remove 'active'
    @ui.presetSteps[++@currentIndex].classList.add 'active'

  onPrevious: (ev) -> 
    ev.preventDefault()
    @ui.presetSteps[@currentIndex].classList.remove 'active'
    @ui.presetSteps[--@currentIndex].classList.add 'active'
