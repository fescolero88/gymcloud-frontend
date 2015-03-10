Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

class ExercisesGlobalItemView extends Marionette.ItemView

  template: Templates.trainer.exercises.single_item

  tagName: 'li'

  className: 'row'

  ui:
    childItemLink: '.gc-exercises-link'
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

  initialize: (data) =>
    @item_id = data.id
    @collection = new Backbone.Collection App.request 'data:exercises'

  onShow: =>
    if @collection.length
      @loadCollection()
    else
      App.vent.on 'assignments:loaded', @loadExercises

  onDestroy: =>
    App.vent.off 'assignments:loaded', @loadExercises

  childEvents:
    'exercise:clicked': 'itemSelected'
    'navigate:exercise': 'itemClicked'

  itemSelected: =>
    @trigger 'exercise:clicked'

  itemClicked: (view, href, key) =>
    @trigger 'navigate:exercise', href, key

  loadCollection: =>
    if @item_id
      searchResults = @searchByKey(new Backbone.Collection(App.request 'data:exercises'), @item_id, ['Exercises'])
      childModel = searchResults.model
      @trigger 'breadcrumbs:change', searchResults.path
      @collection = new Backbone.Collection childModel.get('items')
      @render()
    else
      @render()

  loadExercises: =>
    @collection = new Backbone.Collection App.request 'data:exercises'
    @loadCollection()

  searchByKey: (items, key, breadcrumbs) =>
    filtered = items.where({key: parseInt(key)})
    if filtered.length
      result = filtered[0]
      breadcrumbs.push(result.get 'title')
    else
      items.each (item) =>
        if item.has('items')
          searchResults = @searchByKey(new Backbone.Collection(item.get('items')), key, [item.get 'title'])
          if searchResults.model
            result = searchResults.model
            breadcrumbs = breadcrumbs.concat searchResults.path
    return {model: result, path: breadcrumbs}
