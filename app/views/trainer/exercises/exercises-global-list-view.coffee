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

  itemSelected: =>
    @trigger 'exercise:clicked'
