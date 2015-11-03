define [
  'behaviors/form_validation'
  'behaviors/navigate_back'
  'behaviors/regioned'
  'behaviors/stickit'
  'features/add_to_library/button/behavior'
  'features/author/widget/behavior'
  'features/auto_complete/behavior'
  'features/breadcrumbs/behavior'
  'features/delete_button/behavior'
  'features/editable_textarea/behavior'
  'features/navigation/content_tabs/behavior'
  'features/pagination/behavior'
  'features/privacy/toggle/behavior'
  'features/privacy/widget/behavior'
  'features/rating/widget/behavior'
  'features/video/assigned/behavior'
], ->

  klasses = _.toArray(arguments)

  _.reduce klasses, (memo, klass) ->
    key = _.result(klass::, 'key')
    memo[key] = klass
    memo
  , {}
