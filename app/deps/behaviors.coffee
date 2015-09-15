define [
  'behaviors/stickit'
  'behaviors/form_validation'
  'behaviors/navigate_back'
], (
  StickitBehavior
  FormValidationBehavior
  NavigateBackBehavior
) ->

  Behaviors =
    stickit: StickitBehavior
    form_validation: FormValidationBehavior
    navigate_back: NavigateBackBehavior

  Behaviors
