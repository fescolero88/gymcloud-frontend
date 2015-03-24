Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

module.exports = class AddExerciseFolderModalView extends Marionette.ItemView
  className: 'modal-dialog modal-md'
  template: Templates.trainer.exercises.duplicate_exercise_modal

  ui:
    folderInput: '.gc-folders-input'
    form: '.gc-duplicate-form'

  events:
    'submit @ui.form': 'submitForm'

  initialize: (data) =>
    @exercises = data.exercises

  onShow: =>
    @initSearchSelect()

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

  initSearchSelect: =>
    searchOptions = @searchItems @exercises, 'exercises'
    this_ = @
    @ui.folderInput.selectize
      plugins: ['remove_button']
      hideSelected: true
      valueField: 'key'
      labelField: 'title'
      sortField: 'title'
      searchField: ['title']
      options: searchOptions
      render:
        item: (item, escape) ->
            return '<div>' + escape(item.title) + '</div>'
        option: (item, escape) ->
            return '<div><span class="label">' + escape(item.label) +
              '</span> ' + escape(item.title) + '</div>'

  submitForm: (ev) =>
    ev.preventDefault()
    ids = @ui.folderInput.val().split(',')
    @trigger "exercises:duplicate", ids

