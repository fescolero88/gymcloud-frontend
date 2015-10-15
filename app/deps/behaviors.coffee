define [
  'behaviors/stickit'
  'behaviors/video_assign'
  'behaviors/form_validation'
  'behaviors/navigate_back'
  'behaviors/auto_complete/auto_complete'
  'behaviors/pagination'
], (
  StickitBehavior
  VideoAssignBehavior
  FormValidationBehavior
  NavigateBackBehavior
  AutoCompleteBehavior
  PaginationBehavior
) ->

  Behaviors =
    stickit: StickitBehavior
    video_assign: VideoAssignBehavior
    form_validation: FormValidationBehavior
    navigate_back: NavigateBackBehavior
    auto_complete: AutoCompleteBehavior
    pagination: PaginationBehavior

  Behaviors
