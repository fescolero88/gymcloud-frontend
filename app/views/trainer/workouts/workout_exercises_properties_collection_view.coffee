class WorkoutExerciseProperty extends Marionette.ItemView
  
  tagName: 'li'
  template: require 'templates/trainer/workouts/workout_exercise_property_dropdown_item'

module.exports = class WorkoutExercisePropertyCollectionView extends Marionette.CollectionView

  tagName: 'ul'

  className: 'dropdown-menu gc-dropdown'

  childView: WorkoutExerciseProperty

