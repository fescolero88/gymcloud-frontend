define [
  'behaviors/stickit'
  'behaviors/video_assign'
  'behaviors/form_validation'
  'behaviors/navigate_back'
  'behaviors/auto_complete/auto_complete'
], (
  StickitBehavior
  VideoAssign
  FormValidationBehavior
  NavigateBackBehavior
  AutoCompleteBehavior
) ->

  Behaviors =
    stickit: StickitBehavior
    video_assign: VideoAssign
    form_validation: FormValidationBehavior
    navigate_back: NavigateBackBehavior
    auto_complete: AutoCompleteBehavior

  Behaviors
