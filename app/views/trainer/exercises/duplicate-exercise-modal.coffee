Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

class AddExerciseFolderModalItemView extends Marionette.ItemView
  template: Templates.trainer.exercises.duplicate_exercise_modal_item
  tagName: 'li'

module.exports = class AddExerciseFolderModalView extends Marionette.CompositeView
  className: 'modal-dialog modal-md'
  template: Templates.trainer.exercises.duplicate_exercise_modal
  childView: AddExerciseFolderModalItemView
  childViewContainer: 'ul'

  ui:
    folderInput: '.gc-folders-input'
    form: '.gc-duplicate-form'
    itemsList: '.gc-duplicate-folders-list'

  events:
    'submit @ui.form': 'submitForm'

  initialize: (data) =>
    @exercises = data.exercises

  onShow: =>
    @collection = new Backbone.Collection(@searchItems @exercises, 'exercises')
    @render()

  searchItems: (items, category) =>
    result = []
    $.each items, (index, item) =>
      if item.isFolder
        result.push
          key: item.key
          title: item.title
          label: category
        category = item.title
        result = result.concat @searchItems(item.items, category)
    return result

  submitForm: (ev) =>
    ev.preventDefault()
    ids = []
    for ch in @ui.itemsList.find(':checked')
      ids.push $(ch).data 'id'
    @trigger "exercises:duplicate", ids

