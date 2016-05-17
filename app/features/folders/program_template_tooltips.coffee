define ->

  (view) ->
    [
        id: 0
        uniq_id: 'folder_list_add_program_template'
        element: view.ui.itemAddButton
        title: '''Having created exercises and workouts, you can now combine
                  them and create a program.'''
        content: 'To start creating a program, click this button.'
        docs: '3000048794--webapp-programs-how-to-add-new'
      ,
        id: 1
        uniq_id: 'folder_list_edit_program_template'
        element: '.gc-folder-item .gc-exercises-link:first'
        title: '''Add weeks to your program depending on how long you would like
                  it to last.'''
        content: 'First, click your program.'
        docs: '3000048884--webapp-programs-how-to-set-weeks'
    ]
