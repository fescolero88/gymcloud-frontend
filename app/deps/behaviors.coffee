define [
  'behaviors/stickit'
  'behaviors/video_assign'
  'behaviors/form_validation'
  'behaviors/navigate_back'
  'behaviors/auto_complete/auto_complete'
  'behaviors/pagination'
  'behaviors/facebook_login'
  'behaviors/google_login'
], (
  StickitBehavior
  VideoAssignBehavior
  FormValidationBehavior
  NavigateBackBehavior
  AutoCompleteBehavior
  PaginationBehavior
  FacebookLoginBehavior
  GoogleLoginBehavior
) ->

  Behaviors =
    stickit: StickitBehavior
    video_assign: VideoAssignBehavior
    form_validation: FormValidationBehavior
    navigate_back: NavigateBackBehavior
    auto_complete: AutoCompleteBehavior
    pagination: PaginationBehavior
    facebook_login: FacebookLoginBehavior
    google_login: GoogleLoginBehavior

  Behaviors
