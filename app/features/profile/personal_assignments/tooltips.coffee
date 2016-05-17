define ->

  (view) ->

    [
        id: 0
        uniq_id: 'client_search_to_assign'
        element: $('.gc-exercises-assign-input-wrapper input:last')
        title: 'Assigning Items To A Client'
        content: '''Type here the name of the workout you want to assign and
                    click it.'''
        docs: '3000050220--web-clients-how-to-assign-workouts-and-programs'
        onShow: -> $('.gc-exercises-assign-input-wrapper input').click()
    ]