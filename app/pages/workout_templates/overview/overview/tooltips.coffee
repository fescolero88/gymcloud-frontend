define ->

  (view) ->

    [
        id: 0
        uniq_id: 'workout_constructor_edit_description'
        element: view.$('.gc-editable-textarea textarea')
        title: '''Give your client general information about the workout by
                  adding notes to it.'''
        content: 'Start typing your workout notes / descriptions here.'
        docs: '3000048219--webapp-workouts-how-to-add-descriptions-notes'
      ,
        id: 1
        uniq_id: 'workout_constructor_add_exercise'
        element: '.gc-exercises-list-actions .quick-add'
        title: 'Add Exercise.'
        content: '''Add the exercises you want to include in your workout by
                    clicking here.'''
        docs: '3000048221--webapp-workouts-how-to-add-exercises'
      ,
        id: 2
        uniq_id: 'workout_constructor_add_exercise_note'
        element: '.gc-workout-exercise-note:first'
        title: '''Adding notes to exercises in a workout is useful to help your
                  clients execute exercises correctly.'''
        content: 'Start typing your exercise note(s) here.'
        docs: '3000048276--web-workouts-how-to-add-exercise-notes'
      ,
        id: 3
        uniq_id: 'workout_constructor_add_exercise_property'
        element: '.gc-add-single-property-button:first'
        title: '''Provide your client instructions by adding properties to your
                  exercises in a workout.'''
        content: '''To add properties, hover to your exercise and hit this
                    button.'''
        docs: '3000048272--web-workouts-how-to-add-exercise-properties'
      ,
        id: 4
        uniq_id: 'workout_constructor_add_exercise_order'
        element: '.gc-workout-exercise-circle:first'
        title: '''Change the order of your exercises to alphanumeric. Those that
                  have the same letter are in one set.'''
        content: 'Click here and change its name to A1.'
        docs: '3000048279--webapp-workouts-how-to-connect-exercises-'+
              'to-create-a-set'
    ]
