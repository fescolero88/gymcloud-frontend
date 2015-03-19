Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

class ExercisesGlobalItemView extends Marionette.ItemView
  template: Templates.trainer.exercises.single_item
  tagName: 'li'
  className: 'row'

  ui:
    checkbox: '.gc-exercises-chb input'

  events:
    'click @ui.checkbox': 'itemChecked'

  itemChecked: (ev) =>
    @trigger 'exercise:clicked'

module.exports = class ExercisesGlobalListView extends Marionette.CompositeView
  template: Templates.trainer.exercises.exercises_global_list
  childView: ExercisesGlobalItemView
  childViewContainer: 'ul'
  collectionEvents:
    'sync': 'render'

  childEvents:
    'exercise:clicked': 'itemSelected'

  initialize: =>
    @on 'items:delete', @deleteItems

  itemSelected: =>
    @trigger 'exercise:clicked'

  deleteItems: (ids) =>
    for key in ids
      model = @collection.where({key: key})[0]
      type = if model.get('isFolder') then "folders" else "exercises"
      model.url = "/api/mobile/#{type}/#{model.get 'key'}"
      $.ajax
        method: 'DELETE'
        url: model.url
      model.destroy()
    App.request('data:reload', 'exercises').then ->
      App.request 'messenger:show',
        hideAfter: 5
        message: "Item(s) was deleted"
        type: 'info'
