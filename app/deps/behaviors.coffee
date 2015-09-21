define [
  'behaviors/stickit'
  'behaviors/form_validation'
  'behaviors/navigate_back'
  'behaviors/auto_complete/auto_complete'
], (
  StickitBehavior
  FormValidationBehavior
  NavigateBackBehavior
  AutoCompleteBehavior
) ->

  Behaviors =
    stickit: StickitBehavior
    form_validation: FormValidationBehavior
    navigate_back: NavigateBackBehavior
    auto_complete: AutoCompleteBehavior

  Behaviors
