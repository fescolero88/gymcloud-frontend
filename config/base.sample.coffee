defaults =
  vendor:
    facebook: app_id: '774894325885277'
    google: client_id: '686822539338-h8pp1erjru867em1h45f7rf0qe0ftpdf.apps.googleusercontent.com'
  api: url: undefined
  mobile: url: undefined
  features:
    sign_up: enabled: true
    exercises: enabled: true
    workout_templates: enabled: true
    program_templates: enabled: true
    workout_exercises: enabled: true
    personal_workouts: enabled: true
    personal_programs: enabled: true
    payments: enabled: false
    rating_widget: enabled: false
    user_profile_progress: enabled: false
    user_account_type: enabled: false

module.exports =

  development: $.extend true, {}, defaults,
    vendor:
      facebook: app_id: '774894325885277'
    google: client_id: '686822539338-h8pp1erjru867em1h45f7rf0qe0ftpdf.apps.googleusercontent.com'
    api: url: '//localhost:3000'
    mobile: url: '#'

  staging: $.extend true, {}, defaults,
    vendor:
      facebook: app_id: '1457484574486556'
      google: client_id: '686822539338-h8pp1erjru867em1h45f7rf0qe0ftpdf.apps.googleusercontent.com'
    api: url: '//api.s.gymcloud.com'
    mobile: url: '//mobile.s.gymcloud.com'

  production: $.extend true, {}, defaults,
    vendor:
      facebook: app_id: '444988735644338'
      google: client_id: '512657583504-f9e94bg98gfg0mavfqv84nqthv9o0acg.apps.googleusercontent.com'
    api: url: '//api.gymcloud.com'
    mobile: url: '//mobile.gymcloud.com'
    features:
      sign_up: enabled: false

  test: $.extend true, {}, defaults,
    api: url: ''
    mobile: url: '#'
