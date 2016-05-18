define ->

  (view) ->

    [
        id: 0
        uniq_id: 'clients_add_client'
        element: view.$('.show-client-form:first')
        title: '''Once you established a library of your exercises, workouts and
                  programs, you can now add your clients.'''
        content: 'Hit this button to start adding a client.'
        docs: '3000048490--web-clients-how-to-add-new'
        onNext: -> view.showClientAddModal()
      ,
        id: 1
        uniq_id: 'clients_add_client_form'
        element: '.gc-client-modal input:first'
        title: '''Allow your client to manage his/her own workouts and programs
                  by inviting him/her to Gymcloud.'''
        content: 'First, click your client\'s name.'
        docs: '3000048491--web-clients-how-to-register'
        orphan: true
        onPrev: -> view.ui.modalContainer.modal('hide')
      ,
        id: 2
        uniq_id: 'clients_add_client_form_submit'
        element: '.gc-client-modal button[type="submit"]:first'
        title: 'Inviting A Client To Gymcloud'
        content: 'Then, hit this button and enter your client\'s email address.'
        docs: '3000048491--web-clients-how-to-register'
        onNext: -> view.ui.modalContainer.modal('hide')
      ,
        id: 3
        uniq_id: 'clients_add_group'
        element: view.$('.show-group-form:first')
        title: 'Creating A Client Group.'
        content: '''Creating a group of clients will make it easier for you to
                    batch assign workouts and programs.'''
        docs: '3000048495--web-clients-how-to-create-a-group'
        onPrev: -> view.showClientAddModal()
        onNext: -> view.showGroupAddModal()
      ,
        id: 4
        uniq_id: 'clients_add_group2'
        element: '.modal button[type="submit"]:first'
        title: 'Creating A Client Group.'
        content: 'To create a client group, click here.'
        docs: '3000048495--web-clients-how-to-create-a-group'
        orphan: true
        onPrev: -> view.ui.modalContainer.modal('hide')
        onNext: -> view.ui.modalContainer.modal('hide')
      ,
        id: 5
        uniq_id: 'clients_point_client'
        element: '.gc-clients-list-client-link:first'
        title: 'Moving A Client To A Client Group.'
        content: 'Organize your clients by moving them to a client group.'
        docs: '3000048496--webapp-clients-how-to-add-to-group-through-clients-'+
              'list-page'
        onPrev: -> view.showGroupAddModal()
        onNext: ->
          $('.gc-clients-list-client-actions:first').addClass('active')
      ,
        id: 6
        uniq_id: 'clients_move_client_to_group'
        element: '.gc-clients-list-client-move:first'
        title: 'Moving A Client To A Client Group.'
        content: 'To do this, simply click this button.'
        docs: '3000048496--webapp-clients-how-to-add-to-group-through-clients-'+
              'list-page'
        onPrev: ->
          $('.gc-clients-list-client-actions:first').removeClass('active')
        onNext: ->
          $('.gc-clients-list-client-actions:first').removeClass('active')
      ,
        id: 7
        uniq_id: 'clients_point_client2'
        element: '.gc-clients-list-client-link:first'
        title: 'Assigning Items To A Client.'
        content: '''One of the major features of Gymcloud is to assign a workout
                    or a program to clients and groups.'''
        docs: '3000050220--web-clients-how-to-assign-workouts-and-programs'
        onPrev: ->
          $('.gc-clients-list-client-actions:first').addClass('active')
      ,
        id: 8
        uniq_id: 'clients_point_client3'
        element: '.gc-clients-list-client-link:first'
        title: 'Assigning Items To A Client.'
        content: '''To do this, start by clicking your client's name.'''
        docs: '3000050220--web-clients-how-to-assign-workouts-and-programs'
    ]