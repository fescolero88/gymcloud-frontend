define ->

  (view) ->

    [
        id: 0
        uniq_id: 'exercise_constructor_edit_description'
        element: view.$('.gc-editable-textarea textarea')
        title: '''Give your clients information about the exercise by
                  adding descriptions to it.'''
        content: 'Start typing your exercise description here.'
        docs: '3000047605--webapp-exercises-how-to-add-descriptions'
      ,
        id: 1
        uniq_id: 'exercise_constructor_add_video'
        element: view.$('.gc-add-video')
        title: '''Adding a video to your exercise helps your clients
                  understand the proper execution of an exercise.'''
        content: '''Click either of these buttons to add a video to your
                    exercise.'''
        docs: '3000048220--webapp-workouts-how-to-add-a-video'
    ]