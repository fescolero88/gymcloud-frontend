define [
  './exercise_tooltips'
  './workout_template_tooltips'
  './program_template_tooltips'
], (

  exercise_tooltips
  workout_template_tooltips
  program_template_tooltips
) ->

  (view) ->
    switch view.typeName
      when 'exercises'
        exercise_tooltips(view)
      when 'workout_templates'
        workout_template_tooltips(view)
      when 'program_templates'
        program_template_tooltips(view)
      else
        []
