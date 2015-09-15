define [
  'behaviors/stickit'
  'behaviors/form_validation'
], (
  StickitBehavior
  FormValidationBehavior
) ->

  Behaviors =
    stickit: StickitBehavior
    form_validation: FormValidationBehavior

  Behaviors
